#!/bin/sh

encoded_code="IyEvYmluL3NoCgp3aGlsZSB0cnVlOyBkbwoJcHJpbnRmICJcMDMzWzMyOzFtQ2hvaWNlIHJ1biBzY3JpcHQsIDEgLSBjb25maWd1cmVfemFwcmV0cywgMiAtIGF3Z19jb25maWcsIDMgLSBhd2dfb3BlcmFfY29uZmlnLCA0IC0gYXdnX29wZXJhX2NvbmZpZ19ub19jaGVja19pbnN0YWxsX2F3ZywgNSAtIHVuaXZlcnNhbF9jb25maWcsIDAgLSBleGl0OiBcMDMzWzBtIgoJcmVhZCBjaG9pY2UKCWNhc2UgJGNob2ljZSBpbgoJMSkKCQllY2hvICJSdW5uaWcgc2NyaXB0IGNvbmZpZ3VyZV96YXByZXRzLi4uIgoJCXdnZXQgLS1uby1jaGVjay1jZXJ0aWZpY2F0ZSAtTyAvdG1wL2NvbmZpZ3VyZV96YXByZXRzLnNoIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9Db2RlUm9LNy9PcGVuV1JUX2NvbmZpZ3MvcmVmcy9oZWFkcy9tYWluL2NvbmZpZ3VyZV96YXByZXRzLnNoICYmIGNobW9kICt4IC90bXAvY29uZmlndXJlX3phcHJldHMuc2ggJiYgL3RtcC9jb25maWd1cmVfemFwcmV0cy5zaAoJCWJyZWFrCgkJOzsKCgkyKQoJCWVjaG8gIlJ1bm5pZyBzY3JpcHQgYXdnX2NvbmZpZy4uLiIKCQl3Z2V0IC0tbm8tY2hlY2stY2VydGlmaWNhdGUgLU8gL3RtcC9hd2dfY29uZmlnLnNoIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9Db2RlUm9LNy9PcGVuV1JUX2NvbmZpZ3MvcmVmcy9oZWFkcy9tYWluL2F3Z19jb25maWcuc2ggJiYgY2htb2QgK3ggL3RtcC9hd2dfY29uZmlnLnNoICYmIC90bXAvYXdnX2NvbmZpZy5zaAoJCWJyZWFrCgkJOzsKCTMpCgkJZWNobyAiUnVubmlnIHNjcmlwdCBhd2dfb3BlcmFfY29uZmlnLi4uIgoJCXdnZXQgLS1uby1jaGVjay1jZXJ0aWZpY2F0ZSAtTyAvdG1wL2F3Z19vcGVyYV9jb25maWcuc2ggaHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL0NvZGVSb0s3L09wZW5XUlRfY29uZmlncy9yZWZzL2hlYWRzL21haW4vYXdnX29wZXJhX2NvbmZpZy5zaCAmJiBjaG1vZCAreCAvdG1wL2F3Z19vcGVyYV9jb25maWcuc2ggJiYgL3RtcC9hd2dfb3BlcmFfY29uZmlnLnNoCgkJYnJlYWsKCQk7OwoJNCkKCQllY2hvICJSdW5uaWcgc2NyaXB0IGF3Z19vcGVyYV9jb25maWcuLi4iCgkJd2dldCAtLW5vLWNoZWNrLWNlcnRpZmljYXRlIC1PIC90bXAvYXdnX29wZXJhX2NvbmZpZ19ub19jaGVja19pbnN0YWxsX2F3Zy5zaCBodHRwczovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vQ29kZVJvSzcvT3BlbldSVF9jb25maWdzL3JlZnMvaGVhZHMvbWFpbi9hd2dfb3BlcmFfY29uZmlnX25vX2NoZWNrX2luc3RhbGxfYXdnLnNoICYmIGNobW9kICt4IC90bXAvYXdnX29wZXJhX2NvbmZpZ19ub19jaGVja19pbnN0YWxsX2F3Zy5zaCAmJiAvdG1wL2F3Z19vcGVyYV9jb25maWdfbm9fY2hlY2tfaW5zdGFsbF9hd2cuc2gKCQlicmVhawoJCTs7Cgk1KQoJCWVjaG8gIlJ1bm5pZyBzY3JpcHQgdW5pdmVyc2FsX2NvbmZpZy4uLiIKCQl3Z2V0IC0tbm8tY2hlY2stY2VydGlmaWNhdGUgLU8gL3RtcC91bml2ZXJzYWxfY29uZmlnLnNoIGh0dHBzOi8vcmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbS9Db2RlUm9LNy9PcGVuV1JUX2NvbmZpZ3MvcmVmcy9oZWFkcy9tYWluL3VuaXZlcnNhbF9jb25maWcuc2ggJiYgY2htb2QgK3ggL3RtcC91bml2ZXJzYWxfY29uZmlnLnNoICYmIC90bXAvdW5pdmVyc2FsX2NvbmZpZy5zaAoJCWJyZWFrCgkJOzsKCTApCgkJZWNobyAiR29vZGJ5Li4uIgoJCWJyZWFrCgkJOzsKCgkqKQoJCWVjaG8gIlBsZWFzZSBlbnRlciAxIG9yIDIgb3IgMyBvciA0IG9yIDUiCgkJOzsKCWVzYWMKZG9uZQ=="
eval "$(echo "$encoded_code" | base64 --decode)"