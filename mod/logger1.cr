fun init = crystal_init1 : Void
  # We need to initialize the GC
  GC.init

  # We need to invoke Crystal's "main" function, the one that initializes
  # all constants and runs the top-level code (none in this case, but without
  # constants like STDOUT and others the last line will crash).
  # We pass 0 and null to argc and argv.
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)
end

fun log = crystal_log1(text: UInt8*): Void
  puts "logger1: " + String.new(text)
end
