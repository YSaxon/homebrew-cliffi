class Cliffi < Formula
  desc "Tool for calling shared library functions directly from your shell"
  homepage "https://github.com/YSaxon/cliffi"
  url "https://github.com/YSaxon/cliffi/archive/refs/tags/0.12.5-e5a7c12.tar.gz"
  sha256 "f031f53b0fd78a2b7470ab50ed86f03681648788eec18e552616361282fe7715"
  license "MIT"

  depends_on "cmake" => [:build, :test]
  depends_on "readline" => [:build, :test]
  
  uses_from_macos "libffi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "make", "-C", "build"
    bin.install "build/cliffi"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int add(int a, int b) {
        return a + b;
      }
    EOS
    system ENV.cc, "test.c", "-shared", "-o", "libtest.dylib"
    assert_equal "Function returned: 5", shell_output("#{bin}/cliffi ./libtest.dylib i add 2 3").strip
  end
end
