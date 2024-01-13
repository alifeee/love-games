# Love games!

Games written in <https://love2d.org/>, a framework for making 2D games in Lua.

## To run games

Follow Love [install directions](https://love2d.org/wiki/Getting_Started).

Either run the games with `love` in the terminal (or `lovec` for console support - for `print()`)

```bash
love ./game-directory
```

or drag the folder onto `love.exe`

## To build games into executables

Following instructions from <https://love2d.org/wiki/Game_Distribution>

In Windows, using command prompt (for "catch-ball" game, replace as necessary).

With `love.exe` moved to root repository directory.

```bash
cd catch-ball
tar -a -c -f ../catch-ball.zip *
cd ..
ren catch-ball.zip catch-ball.love
copy /b love.exe+catch-ball.love catch-ball.exe
```

The final game is shareable as `catch-ball.exe`.
