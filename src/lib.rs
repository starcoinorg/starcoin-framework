// Copyright (c) The Starcoin Core Contributors
// SPDX-License-Identifier: Apache-2.0

use std::path::Path;

use include_dir::{include_dir, Dir};
use log::info;
use once_cell::sync::Lazy;
use tempfile::TempDir;
use walkdir::WalkDir;

pub const SOURCES_DIR: Dir = include_dir!("sources");

#[derive(Debug)]
pub struct SourceFiles {
    pub tempdir: TempDir,
}

impl SourceFiles {
    /// Filter all Move source files.
    pub fn files(&self) -> Vec<String> {
        Self::filter_source_files(self.tempdir.path())
    }

    /// Filter Move source files in the given directory.
    pub fn filter_source_files(source_dir: &Path) -> Vec<String> {
        WalkDir::new(source_dir)
            .into_iter()
            .filter_map(Result::ok)
            .filter_map(|file| {
                let ext = file.path().extension();
                if let Some(ext) = ext {
                    if ext == "move" {
                        Some(file.path().display().to_string())
                    } else {
                        None
                    }
                } else {
                    None
                }
            })
            .collect()
    }
}

pub static STARCOIN_FRAMEWORK_SOURCES: Lazy<SourceFiles> =
    Lazy::new(|| restore_sources().expect("Restore source file error"));

//restore the sources files to a tempdir.
fn restore_sources() -> anyhow::Result<SourceFiles> {
    let tempdir = tempfile::tempdir()?;
    let sources_dir = tempdir.path().join("starcoin-framework").join("sources");
    info!("restore starcoin-framework sources in: {:?}", sources_dir);
    std::fs::create_dir_all(sources_dir.as_path())?;
    SOURCES_DIR.extract(sources_dir.as_path())?;
    Ok(SourceFiles { tempdir })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_restore_sources() {
        let sf = restore_sources().unwrap();
        assert_eq!(
            SourceFiles::filter_source_files(
                std::env::current_dir().unwrap().join("sources").as_path()
            )
            .len(),
            sf.files().len(),
            "source file count not equal"
        );
    }
}
