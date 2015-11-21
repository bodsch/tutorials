#
#
#

class monitoring {

  include mysql::server
  include mysql::client

  $databases = hiera_hash('mysql::databases', undef)
  if( $databases ) { create_resources( mysql::db, $databases ) }

  $backup = hiera_hash('mysql::server::backup', undef )
  if( $backup ) { include mysql::server::backup }


  class { 'icinga2':
    require => [
      Class['mysql::server'],
      Class['mysql::client'],
      Mysql::Db[ hiera('icinga2::ido_db_name') ]
    ]
  }

  $icinga2_feature = hiera_hash( icinga2::features, undef )
  if( $icinga2_feature ) { create_resources( icinga2::feature, $icinga2_feature ) }

  $icinga_listener = hiera_hash( 'icinga2::object::livestatuslistener', undef )
  if( $icinga_listener ) { create_resources( icinga2::object::livestatuslistener, $icinga_listener ) }

}

# EOF
