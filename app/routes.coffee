module.exports = (match) ->
  match '', 'home#index'

  match 'profiles', 'profiles#index'
  match 'profiles/new', 'profiles#edit'
  match 'profiles/:id/edit', 'profiles#edit'
  match 'profiles/:id/', 'profiles#show'

  match 'register', 'users#new'
  match 'login', 'session#new'