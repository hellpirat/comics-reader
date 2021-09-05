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
  force: option<bool>,
  maxRetries: option<int>,
  recursive: option<bool>,
  retryDelay: option<int>,
}

@module("fs") external rmSync: (string, rm_options) => unit = "rmSync"

//  export function rmSync(path: PathLike, options?: RmOptions): void;
//      export interface RmOptions {
//         /**
//          * When `true`, exceptions will be ignored if `path` does not exist.
//          * @default false
//          */
//         force?: boolean | undefined;
//         /**
//          * If an `EBUSY`, `EMFILE`, `ENFILE`, `ENOTEMPTY`, or
//          * `EPERM` error is encountered, Node.js will retry the operation with a linear
//          * backoff wait of `retryDelay` ms longer on each try. This option represents the
//          * number of retries. This option is ignored if the `recursive` option is not
//          * `true`.
//          * @default 0
//          */
//         maxRetries?: number | undefined;
//         /**
//          * If `true`, perform a recursive directory removal. In
//          * recursive mode, errors are not reported if `path` does not exist, and
//          * operations are retried on failure.
//          * @default false
//          */
//         recursive?: boolean | undefined;
//         /**
//          * The amount of time in milliseconds to wait between retries.
//          * This option is ignored if the `recursive` option is not `true`.
//          * @default 100
//          */
//         retryDelay?: number | undefined;
//     }
// // 
