#include <stdio.h>
#include <cxxabi.h>

int main(int argc, char** argv) {

	if (argc < 2) {
		printf("Usage: demangle <name...>\n");
		return 1;
	}

	for (int i = 1; i < argc; ++i) {
		char *s = abi::__cxa_demangle(argv[i],0,0,0);
		if (s) printf("%s\n", s);
		else printf("Cannot demangle: %s\n", argv[i]);
	}
}


