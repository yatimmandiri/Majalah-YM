enum Env { development, stagging, production }

const Env env = Env.development;

const googleAPIKey = '';

const baseUrlList = {
  Env.development: 'https://api.yatimmandiri.org',
  Env.stagging: 'https://',
  Env.production: 'https://',
};

final baseURL = baseUrlList[env];
