import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaContols extends StatefulWidget {
  const TriviaContols({
    Key key,
  }) : super(key: key);

  @override
  State<TriviaContols> createState() => _TriviaContolsState();
}

class _TriviaContolsState extends State<TriviaContols> {
  final controller = TextEditingController();
  String inputString;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Text field
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: "Input a number"),
          onChanged: (value) {
            inputString = value;
          },
          onSubmitted: (_) => dispatchConcrete(),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                textTheme: ButtonTextTheme.primary,
                child: const Text("Search"),
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: const Text("Get random trivia"),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputString));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
