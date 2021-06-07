# Flake 1

An example package which has specific dependencies at build time.


## Reproducability

The maintainer created the flake while on revision `67be794a7f1102c752ab0d00c6ca58652009e67e` of nixpkgs.

There is a hard requirement on _node v14.16.1_.

It built and ran fine **on their system**.

### Outdated registry

A new user tries to use the flake but has an outdated version of the registry installed (`41d2099728a7bf68b1a435219ceedc8423f15f39`).

Rather than being informed by the registry that a required dependency (node@14.16.1) is missing, the build process begins and fails.

Because the build is failing, the user assumes there is an issue with the flake and submits a bug report to the maintainer.

### Updated registry

A new user tries to use the flake but has a newly released version of the registry installed (`3e8eec9329c4aea491fac06b23db001a3cd19f84`).

Rather than being informed by the registry that a dependency is missing (node@14.16.1), the build process begins and fails.

Because the build is failing, the user assumes there is an issue with the flake and submits a bug report to the maintainer.

## Ideal situation

The flake would declare the version constraints explicitly

```nix
# For example purposes - actual implementation my vary
nativeBuildInputs = with pkgs; [
  (versioned { package = nodejs; version = "14.16.1" })
];
```

### Outdated registry
At dependency resolution time (before build) if the requested version of the package couldn't be found, the user would get an error such as:

> Error resolving dependency `nodejs` with version constraint `14.16.1` - is nixpkgs up to date?


### Updated registry

Because previous releases of packages are versioned and kept, newer versions of the registry would not introduce breaking changes (so this "just works").

# Flake 2

An example package which has specific dependencies at build time.

## Pinning 

The maintainer created the flake while on revision `67be794a7f1102c752ab0d00c6ca58652009e67e` of nixpkgs.

There is a hard requirement on _node >=v14.16.1 <15.0.0_.

The version of nixpkgs is pinned as an input to the flake to ensure reproducability.

### Security vulnerability

Shortly after the release, a major security vulnerability is found in node v14.16.1 and is quickly patched to v14.16.2.

A user with a completely up-to-date system installs the flake and discovers the flake is pinned to a vulnerable version of nodejs.

The user then submits an issue/PR to the maintainer to get the issue resolved. In the meantime, they maintain a fork.

## Ideal situation

The flake would declare the version constraints explicitly

```nix
# For example purposes - actual implementation my vary
nativeBuildInputs = with pkgs; [
  (versioned { package = nodejs; version = ">=14.16.1 <15.0.0" })
];
```

### Security vulnerability

Because versions are semver complaint and pinned to a range, patch & minor releases could be automatically resolved without needing the flake to be updated on every registry release. 

# Flake 3

A user is managing their nixOS installation using flakes. They want to be as up-to-date as possible while also sticking to the previous release of gnome (3.38 rather than 3.40).

They overlay the Gnome packages in the hope that this will keep them on the version they want.

At build time, nix package resolution succeeds because all dependent packages (by name) are present but build fails due to package versioning issues. 

Some of the packages that were overlayed have transitive dependencies which, on the unstable registry, have gone through major releases (breaking changes). The user would have to overlay all transitive dependencies in order to get around this issue, which could in turn break packages on the "main" registry version

> Note: This one I'm not so sure about what is going on under the hud so let me know and I'll correct it!

## Ideal situation

Dependencies for the overlayed package would be explicitly versioned (similar to the above proposed solutions). 

Because of this, even if the latest nixpkgs version is used, any overlayed packages would constraint transitive dependencies by version.

At dependency resolution time (before build) if the requested version of the package couldn't be found the user would be informed.