id: qoedvk82xtp01pt6w062hh2jshjx31dtd2ikxmb580ogjgzy
name: libpcre
main: src/main.zig
license: MIT
description: Zig bindings to libpcre
dependencies:
  - src: system_lib pcre
    only_os: windows

  - src: system_lib libpcre
    except_os: windows
