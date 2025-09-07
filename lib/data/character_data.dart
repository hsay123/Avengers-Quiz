import '../models/quiz_models.dart';

class CharacterData {
  static final Map<String, Character> characters = {
    'iron_man': Character(
      id: 'iron_man',
      name: 'Iron Man',
      avatar: 'assets/images/ironman.jpg',
      description:
          "Like Tony Stark, you're a brilliant innovator with a sharp wit and natural leadership abilities. You approach challenges with intelligence and creativity, always looking for technological solutions. Your confidence and charisma inspire others, though you sometimes struggle with vulnerability. You're driven by a desire to protect and improve the world around you.",
      traits: [
        'Highly intelligent and analytical',
        'Natural leader and innovator',
        'Quick-witted with sharp humor',
        'Confident and charismatic',
        'Sometimes struggles with emotional vulnerability'
      ],
      strengths: [
        'Problem-solving and strategic thinking',
        'Technological innovation and creativity',
        'Leadership and team coordination',
        'Adaptability under pressure',
        'Strong moral compass despite flaws'
      ],
      funFacts: [
        "You probably love gadgets and the latest technology",
        "You're likely the one friends turn to for advice",
        "You have a tendency to work late into the night",
        "You appreciate quality and attention to detail",
        "You're not afraid to take calculated risks"
      ],
    ),
    'captain_america': Character(
      id: 'captain_america',
      name: 'Captain America',
      avatar: 'assets/images/captan america.jpg',
      description:
          "Like Steve Rogers, you embody unwavering moral principles and natural leadership. You stand up for what's right, even when it's difficult, and inspire others through your actions. Your sense of duty and honor drives you to protect those who can't protect themselves. You believe in the power of doing the right thing, regardless of personal cost.",
      traits: [
        'Uncompromising moral compass',
        'Natural born leader',
        'Courageous and selfless',
        'Disciplined and determined',
        'Inspires loyalty in others'
      ],
      strengths: [
        'Strategic planning and tactics',
        'Physical and mental resilience',
        'Team building and motivation',
        'Crisis management under pressure',
        'Unwavering dedication to justice'
      ],
      funFacts: [
        "You're probably the friend everyone turns to for guidance",
        "You have strong opinions about right and wrong",
        "You're willing to make personal sacrifices for others",
        "You appreciate traditional values and honor",
        "You're not afraid to stand alone for your beliefs"
      ],
    ),
    'thor': Character(
      id: 'thor',
      name: 'Thor',
      avatar: 'assets/images/Thor.jpg',
      description:
          "Like the God of Thunder, you combine great power with a noble heart. You approach life with passion and honor, always ready to protect those you care about. Your strength comes not just from your abilities, but from your willingness to grow and learn. You value friendship, loyalty, and the bonds that unite us across all realms.",
      traits: [
        'Noble and honorable',
        'Passionate and enthusiastic',
        'Loyal and protective',
        'Strong sense of duty',
        'Capable of great growth and wisdom'
      ],
      strengths: [
        'Raw power and combat prowess',
        'Ancient wisdom and experience',
        'Unwavering loyalty to friends',
        'Natural charisma and presence',
        'Ability to inspire hope in others'
      ],
      funFacts: [
        "You probably enjoy celebrations and good company",
        "You're fiercely protective of your friends and family",
        "You have a dramatic flair and love grand gestures",
        "You appreciate tradition and ancient wisdom",
        "You're not afraid to show your emotions openly"
      ],
    ),
    'hulk': Character(
      id: 'hulk',
      name: 'Hulk',
      avatar: 'assets/images/Hulk.jpg',
      description:
          "Like Bruce Banner, you possess incredible inner strength, even if you sometimes struggle to control it. You're deeply empathetic and driven by a desire to help others, though you may fear your own potential for harm. Your greatest battles are often internal, and your true power comes from learning to balance your different sides.",
      traits: [
        'Incredibly strong both physically and emotionally',
        'Deeply empathetic and caring',
        'Struggles with inner conflict',
        'Highly intelligent and scientific mind',
        'Protective of the innocent'
      ],
      strengths: [
        'Unmatched raw power and resilience',
        'Scientific genius and problem-solving',
        'Deep emotional intelligence',
        'Unwavering moral principles',
        'Ability to overcome any obstacle'
      ],
      funFacts: [
        "You probably prefer quiet, peaceful environments",
        "You're incredibly loyal once trust is earned",
        "You may struggle with anger management at times",
        "You're likely very intelligent and analytical",
        "You care deeply about protecting the innocent"
      ],
    ),
    'black_widow': Character(
      id: 'black_widow',
      name: 'Black Widow',
      avatar: 'assets/images/blackwido.jpg',
      description:
          "Like Natasha Romanoff, you're incredibly resourceful and adaptable. You've overcome a difficult past to become someone who fights for others. Your strength lies in your intelligence, agility, and ability to read people and situations. You're fiercely loyal to those who earn your trust, and you'll do whatever it takes to protect them.",
      traits: [
        'Highly skilled and adaptable',
        'Excellent judge of character',
        'Resourceful problem solver',
        'Fiercely loyal to trusted allies',
        'Strong survivor instincts'
      ],
      strengths: [
        'Strategic thinking and planning',
        'Exceptional combat and stealth skills',
        'Master of deception and infiltration',
        'Strong emotional intelligence',
        'Ability to work in any environment'
      ],
      funFacts: [
        "You're probably very observant of others' behavior",
        "You prefer to work behind the scenes",
        "You're excellent at reading between the lines",
        "You value competence and efficiency",
        "You're incredibly loyal but selective with trust"
      ],
    ),
  };

  static Character? getCharacterById(String id) {
    return characters[id];
  }

  static List<Character> getAllCharacters() {
    return characters.values.toList();
  }
}
