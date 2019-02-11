﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьФормуПоОбъекту();
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		Элементы.СклонениеЦелойЧасти.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.ГруппаПараметрыДробнойЧасти.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.ГруппаПримерПрописи.ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		Элементы.СуммаПрописью.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Верх;
		Элементы.СуммаПрописью.Высота = 2;
		Элементы.СуммаПрописью.МногострочныйРежим = Истина;
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СуммаЧислоПриИзменении(Элемент)
	
	УстановитьСуммуПрописью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомПриИзменении(Элемент)
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи4наРусскомОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомПриИзменении(Элемент)
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи8наРусскомОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи1наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи2наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи3наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи5наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи6наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ПолеПрописи7наРусскомПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиПриИзменении(Элемент)
	УстановитьСуммуПрописью(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	ДанныеВыбора = АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДлинаДробнойЧастиОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	ДанныеВыбора = ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Установить(Команда)
	Закрыть(ПараметрыПрописиНаРусском(ЭтотОбъект));
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	ПрочитатьПараметрыПрописи();
	
	УстановитьСклоненияПараметровПрописи(ЭтотОбъект);
	УстановитьСуммуПрописью(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыПрописиНаРусском(Форма)
	
	Возврат Форма.ПолеПрописи1наРусском + ", "
			+ Форма.ПолеПрописи2наРусском + ", "
			+ Форма.ПолеПрописи3наРусском + ", "
			+ НРег(Лев(Форма.ПолеПрописи4наРусском, 1)) + ", "
			+ Форма.ПолеПрописи5наРусском + ", "
			+ Форма.ПолеПрописи6наРусском + ", "
			+ Форма.ПолеПрописи7наРусском + ", "
			+ НРег(Лев(Форма.ПолеПрописи8наРусском, 1)) + ", "
			+ Форма.ДлинаДробнойЧасти;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСуммуПрописью(Форма)
	
	Форма.СуммаПрописью = ЧислоПрописью(Форма.СуммаЧисло, , ПараметрыПрописиНаРусском(Форма));
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьПараметрыПрописи()
	
	// Считывает параметры прописи и заполняет соответствующие поля диалога.
	
	СтрокаПараметров = СтрЗаменить(Параметры.ПараметрыПрописи, ",", Символы.ПС);
	
	ПолеПрописи1наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 1));
	ПолеПрописи2наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 2));
	ПолеПрописи3наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 3));
	
	Род = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 4));
	
	Если НРег(Род) = "м" Тогда
		ПолеПрописи4наРусском = "Мужской";
	ИначеЕсли НРег(Род) = "ж" Тогда
		ПолеПрописи4наРусском = "Женский";
	ИначеЕсли НРег(Род) = "с" Тогда
		ПолеПрописи4наРусском = "Средний";
	КонецЕсли;
	
	ПолеПрописи5наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 5));
	ПолеПрописи6наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 6));
	ПолеПрописи7наРусском = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 7));
	
	Род = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 8));
	
	Если НРег(Род) = "м" Тогда
		ПолеПрописи8наРусском = "Мужской";
	ИначеЕсли НРег(Род) = "ж" Тогда
		ПолеПрописи8наРусском = "Женский";
	ИначеЕсли НРег(Род) = "с" Тогда
		ПолеПрописи8наРусском = "Средний";
	КонецЕсли;
	
	ДлинаДробнойЧасти = СокрЛП(СтрПолучитьСтроку(СтрокаПараметров, 9));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСклоненияПараметровПрописи(Форма)
	
	// Склонение заголовков параметров прописи.
	
	Элементы = Форма.Элементы;
	
	Если Форма.ПолеПрописи4наРусском = "Женский" Тогда
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Одна'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Две'");
	ИначеЕсли Форма.ПолеПрописи4наРусском = "Мужской" Тогда
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Один'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Два'");
	Иначе
		Элементы.ПолеПрописи1наРусском.Заголовок = НСтр("ru = 'Одно'");
		Элементы.ПолеПрописи2наРусском.Заголовок = НСтр("ru = 'Два'");
	КонецЕсли;
	
	Если Форма.ПолеПрописи8наРусском = "Женский" Тогда
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Одна'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Две'");
	ИначеЕсли Форма.ПолеПрописи8наРусском = "Мужской" Тогда
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Один'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Два'");
	Иначе
		Элементы.ПолеПрописи5наРусском.Заголовок = НСтр("ru = 'Одно'");
		Элементы.ПолеПрописи6наРусском.Заголовок = НСтр("ru = 'Два'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция АвтоПодборПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка)
	
	// Вспомогательная функция управлением вводом.
	
	Для Каждого ЭлементВыбора Из Элемент.СписокВыбора Цикл
		Если ВРег(Текст) = ВРег(Лев(ЭлементВыбора.Представление, СтрДлина(Текст))) Тогда
			Результат = Новый СписокЗначений;
			Результат.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
			СтандартнаяОбработка = Ложь;
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Функция ОкончаниеВводаТекстаПоСпискуВыбора(Элемент, Текст, СтандартнаяОбработка)
	
	// Вспомогательная функция управлением вводом.
	
	СтандартнаяОбработка = Ложь;
	
	Для Каждого ЭлементВыбора Из Элемент.СписокВыбора Цикл
		Если ВРег(Текст) = ВРег(ЭлементВыбора.Представление) Тогда
			СтандартнаяОбработка = Истина;
		ИначеЕсли ВРег(Текст) = ВРег(Лев(ЭлементВыбора.Представление, СтрДлина(Текст))) Тогда
			СтандартнаяОбработка = Ложь;
			Результат = Новый СписокЗначений;
			Результат.Добавить(ЭлементВыбора.Значение, ЭлементВыбора.Представление);
			Возврат Результат;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

