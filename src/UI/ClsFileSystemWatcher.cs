﻿using System.IO;

namespace AITool
{
    public class ClsFileSystemWatcher
    {
        public string Name = "";
        public string Path = "";
        public bool HasError = false;
        public bool IncludeSubdirectories = false;
        public FileSystemWatcher watcher = null;
        public ClsFileSystemWatcher(string Name, string Path, FileSystemWatcher Watcher, bool IncludeSubFolders)
        {
            this.Name = Name;
            this.Path = Path;
            this.watcher = Watcher;
            this.IncludeSubdirectories = IncludeSubFolders;
            this.watcher.InternalBufferSize = 65536;  //defaults to 8k, we are going max it out to try to prevent "too many changes at once in directory"
        }
    }
}
