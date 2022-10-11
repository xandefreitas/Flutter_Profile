import 'package:flutter_profile/common/models/company.dart';
import 'package:flutter_profile/common/models/occupation.dart';

// ignore: non_constant_identifier_names
final CompanyData = [
  Company(
    name: 'Solutis Tecnologias',
    occupations: [
      Occupation(
        role: 'Coder Trainee',
        startDate: 'Dez 2020',
        endDate: 'Jun 2021',
        description: 'Transformação de idéias dos designers em aplicações reais utilizando Flutter.',
        isCurrentOccupation: false,
      ),
      Occupation(
        role: 'Desenvolvedor Júnior',
        startDate: 'Jun 2021',
        endDate: 'Set 2021',
        description: 'Planejamento e desenvolvimento de interfaces buscando aprimorar a experiência de uso do produto.',
        isCurrentOccupation: false,
      ),
      Occupation(
        role: 'Desenvolvedor de Software',
        startDate: 'Set 2021',
        endDate: 'Abr 2022',
        description: 'Introdução a metodologias ágeis e boas práticas para melhorar o desenvolvimento de produtos.',
        isCurrentOccupation: false,
      ),
      Occupation(
        role: 'Desenvolvedor de Software II',
        startDate: 'Abr 2022',
        endDate: 'O momento',
        description: 'Treinamento de novos desenvolvedores em Flutter e discussões de problemas para gerar soluções e aplicar as melhores práticas.',
        isCurrentOccupation: true,
      ),
    ],
  ),
];
