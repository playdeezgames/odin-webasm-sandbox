package main

import "core:fmt"

check_count: int = 0

CHECK_COMMAND :: "CHECK_COMMAND"

@(export)
step :: proc(dt: f32) -> bool {
    if js_can_read() {
        buf: [256]byte
        name := read_input(buf[:])
        if name == CHECK_COMMAND {
            check_count += 1
        }
        update()
    }
    return true
}

read_input :: proc(buf: []byte) -> string {
    n := int(js_read(raw_data(buf), i32(len(buf))))
    n = min(n, len(buf))
    return string(buf[:n])
}

foreign import "my_env"

@(default_calling_convention="contextless")
foreign my_env {
    js_clear :: proc() ---
    js_write :: proc(text: string) ---
    js_can_read :: proc() -> bool ---
    js_read :: proc(buf: [^]byte, cap: i32) -> i32 ---
    js_add_button :: proc(text: string, command:string) ---
}

update :: proc() {
    js_clear()
    js_write(fmt.tprintf("Checks: %d", check_count))
    js_add_button("Check It!", CHECK_COMMAND)
}

main :: proc() {
    update()
}