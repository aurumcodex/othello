from macros import error

# [===== Configuration defaults ================]
--cc:clang
--gc:orc
--d:quick
--opt:size
--parallelBuild:0
--threads:on
--verbosity:1
--passC:"-flto"
--passL:"-flto"

# [===== musl Configuration ====================]
# -d:musl
when defined(musl):
  echo "[-d:musl] Building static binary with musl"
  var muslPath = findExe("musl-gcc")

  if muslPath == "":
    error "'musl-gcc' not found in $PATH"
  switch "gcc.exe", muslPath
  switch "gcc.linkerexe", muslPath
  switch "passL", "-static"
