#
# custom logic for couchdb json resolution
#

unless nodes_like_me['services' => 'couchdb']['couch.master' => true].any?
  raise 'node `%s`, environment `%s`: there must be at least one node with couch.master set to `true` for this environment.' % [@node.name, @node.environment]
end

if couch.master
  if nodes_like_me['services' => 'couchdb']['couch.master' => true].size > 1
    apply_partial 'services/_couchdb_multimaster.json'
  else
    apply_partial 'services/_couchdb_master.json'
  end
else
  apply_partial 'services/_couchdb_mirror.json'
end

