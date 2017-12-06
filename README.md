# ansible-role-iked

Manage `iked(8)`, aka [OpenIKED](http://www.openiked.org/)

# Requirements

None

# Role Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `iked_user` | | `{{ __iked_user }}` |
| `iked_group` | | `{{ __iked_group }}` |
| `iked_service` | | `iked` |
| `iked_conf_dir` | | `{{ __iked_conf_dir }}` |
| `iked_conf_file` | | `{{ __iked_conf_file }}` |
| `iked_flags` | | `""` |
| `iked_config` | | `""` |


## OpenBSD

| Variable | Default |
|----------|---------|
| `__iked_user` | `_iked` |
| `__iked_group` | `_iked` |
| `__iked_conf_dir` | `/etc/iked` |
| `__iked_conf_file` | `/etc/iked.conf` |

# Dependencies

None

# Example Playbook

```yaml
- hosts: localhost
  roles:
    - ansible-role-iked
  vars:
    iked_flags: -v
    iked_config: |
      ikev2 "win7" esp \
          from 0.0.0.0/0 to 172.16.2.0/24 \
          peer 10.0.0.0/8 local 192.168.56.0/24 \
          eap "mschap-v2" \
          config address 172.16.2.1 \
          tag "$name-$id"
```

# License

```
Copyright (c) 2017 Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

# Author Information

Tomoyuki Sakurai <tomoyukis@reallyenglish.com>

This README was created by [qansible](https://github.com/trombik/qansible)
