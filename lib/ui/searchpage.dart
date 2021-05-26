import 'package:flutter/material.dart';

// Search Menu
// This page is where
// a user can conduct
// search using keyword
// for surah title, word
// in surah

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class SearchPageContainer extends StatefulWidget {
  const SearchPageContainer({Key? key}) : super(key: key);

  @override
  _SearchPageContainerState createState() => _SearchPageContainerState();
}

class _SearchPageContainerState extends State<SearchPageContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "My name? Oh let me tell you my name. Uh, I'm confused. Because uh you know, like we're supposed to believe in the ministry, right? Is a confused person get a resolution? I don't understand. You see, when you go like that, right, you have a cross, right. Two sticks, right. And that's how I felt when I was in Waterloo. Cuz when I walked in Waterloo and smiled at people, they treated me like a vampire. They used the cross and they went like this by not smiling at me. In Toronto, hey hi guys, you know me. Steve Spiros. Easy going? Those who know me, I'm a nobody. You understand? And you can't kill a person with no body. So, why am I afraid? I'm not afraid. I'm afraid of the boogeyman, who is the Boogeyman? You figure it out! I'm going back to Waterloo where the vampires hang out! And I'm going to wear my sunglasses at night. You know why? Because women show their tits, have short skirts, and they feel violated when I look at them! Why? Because I have sunglasses on and I'm weird. Uh, I'm from humberside. I'm sorry if I made a fool of humberside. But all those people who called me a sleepwalker, I woke up. now I'm going back to sleep because I'm going to be committed in an isolation room, because I'm going back to the ministry and allow them to perceive me as I am! A fuck up! Goodbye! Hey Toronto the good. Look at the square! It was a shithole when I worked here. Now it looks like New York Manhattan! Where are the bums? There's no bums here. Toronto doesn't have bums. But Waterloo, they're creating bums! They created me. Why? I don't know. Maybe it's the church. Talk to the pope, he knows everything. I had it! I'm gonna die! How can you die, when you're dead. Oh wait a second, I'm going to be crucified, right? I'm not going to raise my voice, because I'm committed to the Lord. I love you.",
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }
}

