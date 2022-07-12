@[Link("logger1")]
lib LibLogger1
  fun crystal_init1
  fun crystal_log1(text : LibC::Char*)
end

def main
  LibLogger1.crystal_init1
  LibLogger1.crystal_log1("Hello world!");
end

main
