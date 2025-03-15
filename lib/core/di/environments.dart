enum Environment {
  mock(''),
  latest('https://jsonplaceholder.typicode.com');

  const Environment(this.url);

  final String url;
}
