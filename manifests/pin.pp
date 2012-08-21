# pin.pp
# pin a release in apt, useful for unstable repositories

define apt::pin(
  $ensure     = present,
  $order      = 50,
  $packages   = '*',
  $priority   = 0,
  $release    = '',
  $origin     = '',
  $originator = ''
) {

  include apt::params

  $preferences_d = $apt::params::preferences_d

  if ! is_integer($order) {
    fail('Only integers are allowed in the apt::pin order param')
  }

  if $release != '' {
    $pin = "release a=${release}"
  } elsif $origin != '' {
    $pin = "origin \"${origin}\""
  } elsif $originator != '' {
    $pin = "release o=${originator}"
  } else {
    $pin = "release a=${name}"
  }

  file { "${name}.pref":
    ensure  => $ensure,
    path    => "${preferences_d}/${order}-${name}.pref",
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template("apt/pin.pref.erb"),
  }
}
