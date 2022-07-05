import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';

// ignore: non_constant_identifier_names
final CompanyData = [
  Company(
    name: 'Solutis Tecnologias',
    occupations: [
      Occupation(
        role: 'Coder Trainee',
        sinceDate: 'Dez 2020',
        untilDate: 'Jun 2021',
        description: 'Transformação de idéias dos designers em aplicações reais utilizando Flutter.',
        occupationType: 0,
      ),
      Occupation(
        role: 'Desenvolvedor Júnior',
        sinceDate: 'Jun 2021',
        untilDate: 'Set 2021',
        description: 'Planejamento e desenvolvimento de interfaces buscando aprimorar a experiência de uso do produto.',
        occupationType: 1,
      ),
      Occupation(
        role: 'Desenvolvedor de Software',
        sinceDate: 'Set 2021',
        untilDate: 'Abr 2022',
        description: 'Introdução a metodologias ágeis e boas práticas para melhorar o desenvolvimento de produtos.',
        occupationType: 1,
      ),
      Occupation(
        role: 'Desenvolvedor de Software II',
        sinceDate: 'Abr 2022',
        untilDate: 'O momento',
        description: 'Treinamento de novos desenvolvedores em Flutter e discussões de problemas para gerar soluções e aplicar as melhores práticas.',
        occupationType: 1,
      ),
    ],
  ),
  Company(
    name: 'Google',
    occupations: [
      Occupation(
        role: 'Desenvolvedor Flutter',
        sinceDate: 'Dez 2017',
        untilDate: 'Jun 2018',
        description: 'Transformação de idéias dos designers em aplicações reais utilizando Flutter.',
        occupationType: 0,
      ),
      Occupation(
        role: 'Desenvolvedor Flutter Pleno',
        sinceDate: 'Jun 2018',
        untilDate: 'Abr 2019',
        description: 'Introdução a metodologias ágeis e boas práticas para melhorar o desenvolvimento de produtos.',
        occupationType: 1,
      ),
      Occupation(
        role: 'Desenvolvedor Flutter Senior',
        sinceDate: 'Abr 2019',
        untilDate: 'Dez 2020',
        description: 'Treinamento de novos desenvolvedores em Flutter e discussões de problemas para gerar soluções e aplicar as melhores práticas.',
        occupationType: 2,
      ),
    ],
  ),
];
