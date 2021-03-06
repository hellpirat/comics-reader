module Stats = {
  type t = {
    dev: int,
    ino: int,
    mode: int,
    nlink: int,
    uid: int,
    gid: int,
    rdev: int,
    size: int,
    blksize: int,
    blocks: int,
    atimeMs: int,
    mtimeMs: int,
    ctimeMs: int,
    birthtimeMs: int,
    atime: string,
    mtime: string,
    ctime: string,
    birthtime: string,
  }

  @send external isDirectory: t => bool = "isDirectory"
}

@module("fs") external readdirSync: string => array<string> = "readdirSync"

@module("fs") external statSync: string => Stats.t = "statSync"

@module("fs") external mkdirSync: string => unit = "mkdirSync"

@module("fs") external renameSync: (string, string) => unit = "renameSync"

type rm_options = {
  force: bool,
  recursive: bool,
}

@module("fs") external rmSync: (string, rm_options) => unit = "rmSync"

@module("fs") external copyFileSync: (string, string) => unit = "copyFileSync"

// TODO: Returns: <fs.ReadStream> See Readable Stream.
@module("fs") external createReadStream: string => string = "createReadStream"
