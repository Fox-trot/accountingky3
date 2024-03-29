﻿// Форма вызывается из:
// Документ.НачислениеЗарплаты.ФормаДокумента
// Документ.НачислениеЗарплаты.ФормаСписка
// Документ.ПлатежнаяВедомость.ФормаДокумента
// Документ.ПлатежнаяВедомость.ФормаСписка
// Документ.РасходИзКассы.ФормаДокумента
// Документ.Табель.ФормаДокумента

#Область СлужебныеПроцедурыИФункции

// Процедура обработки ожидания при активизации даты.
//
&НаКлиенте
Процедура ОбработкаОжидания()
	
	Для каждого ВыделеннаяДата Из Элементы.ДатаКалендаря.ВыделенныеДаты Цикл
		
		ДатаКалендаря = ВыделеннаяДата;
		
	КонецЦикла;
	
	ОповеститьОВыборе(ДатаКалендаря);
	
КонецПроцедуры // ОбработкаОжидания()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ДатаКалендаря", ДатаКалендаря)
	
КонецПроцедуры // ПриСозданииНаСервере()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

// Процедура - обработчик события ПриАктивизацииДаты поля ДатаКалендаря.
//
&НаКлиенте
Процедура ДатаКалендаряПриАктивизацииДаты(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработкаОжидания", 0.2, Истина);
	
КонецПроцедуры // ДатаКалендаряПриАктивизацииДаты()

#КонецОбласти
