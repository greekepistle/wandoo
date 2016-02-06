var opening = ['Let\'s', 'I want to', 'Anyone down to', 'Whos up to', 'Who wants to'];

var verbs = ['eat',
  'travel', 
  'bake', 
  'run',
  '',
  'watch',
  'get',
  'see',
  'play',
  'read',
  'cook',
  'buy',
  'meet',
  'compare',
  'purchase',
  'lend',
  'make',
  'go to'
  ];

var nouns = ['peanuts',
  'museum',
  'food',
  'cookies',
  'hamburgers',
  'frosting',
  'lettuce',
  'pickles',
  'onions',
  'relish',
  'cake',
  'supremes',
  'City and Colour',
  'basketball',
  'Britney Spears',
  'lava',
  'lightning',
  'forest',
  'yarn',
  'cattle',
  'Snow White',
  'school',
  'Costco',
  'roses',
  'basketball',
  'The Giver',
  'Socrates',
  'Trump',
  'P Diddy',
  'grains of salt',
  'spasm',
  'iPhone',
  'charger',
  'ball handlers',
  'apricot',
  'papaya',
  'money',
  'boxes',
  'Show Dogs',
  'ice cream',
  'oranges',
  'frosting',
  'icicles',
  'lemons',
  'fruitcake',
  'deoderant',
  'dinner',
  'supper',
  'date',
  'Jose Bautista',
  'George',
  'Christina',
  'people',
  'Italian food',
  'desert',
  'grocery store',
  'Stephen Curry',
  'aliens'
];

var randomElement = function(array){
  var randomIndex = Math.floor(Math.random() * array.length);
  return array[randomIndex];
};

var generateRandomWandoo = function () {
  return randomElement(opening) + ' ' + randomElement(verbs) + ' ' + randomElement(nouns);
}

module.exports = generateRandomWandoo;
