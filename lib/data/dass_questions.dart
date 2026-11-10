import 'package:betteryou_co/models/dass_model.dart';

/// The official 21-item DASS-21 instrument, in its standard published
/// item order (Lovibond & Lovibond). Items are interleaved across the
/// three subscales — this order is the source of truth, not a grouping.
const List<DassQuestionModel> dassQuestions = [
  DassQuestionModel(
    id: 1,
    text: "I found it hard to wind down",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 2,
    text: "I was aware of dryness of my mouth",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 3,
    text: "I couldn't seem to experience any positive feeling at all",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 4,
    text:
        "I experienced breathing difficulty (e.g. excessively rapid breathing, breathlessness in the absence of physical exertion)",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 5,
    text: "I found it difficult to work up the initiative to do things",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 6,
    text: "I tended to over-react to situations",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 7,
    text: "I experienced trembling (e.g. in the hands)",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 8,
    text: "I felt that I was using a lot of nervous energy",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 9,
    text:
        "I was worried about situations in which I might panic and make a fool of myself",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 10,
    text: "I felt that I had nothing to look forward to",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 11,
    text: "I found myself getting agitated",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 12,
    text: "I found it difficult to relax",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 13,
    text: "I felt down-hearted and blue",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 14,
    text:
        "I was intolerant of anything that kept me from getting on with what I was doing",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 15,
    text: "I felt I was close to panic",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 16,
    text: "I was unable to become enthusiastic about anything",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 17,
    text: "I felt I wasn't worth much as a person",
    subscale: DassSubscale.depression,
  ),
  DassQuestionModel(
    id: 18,
    text: "I felt that I was rather touchy",
    subscale: DassSubscale.stress,
  ),
  DassQuestionModel(
    id: 19,
    text:
        "I was aware of the action of my heart in the absence of physical exertion (e.g. sense of heart rate increase, heart missing a beat)",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 20,
    text: "I felt scared without any good reason",
    subscale: DassSubscale.anxiety,
  ),
  DassQuestionModel(
    id: 21,
    text: "I felt that life was meaningless",
    subscale: DassSubscale.depression,
  ),
];
