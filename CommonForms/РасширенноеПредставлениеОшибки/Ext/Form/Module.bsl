﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Параметры.ЗаголовокПредупреждения;
	АвтоЗаголовок = Ложь;
	
	ТекстОшибкиКлиент = Параметры.ТекстОшибкиКлиент;
	ТекстОшибкиСервер = Параметры.ТекстОшибкиСервер;
	
	КлючНазначенияИспользования = "";
	УстановитьЭлементы(ТекстОшибкиКлиент);
	УстановитьЭлементы(ТекстОшибкиСервер, Истина);
	
	Если Не ПустаяСтрока(ТекстОшибкиКлиент)
		И Не ПустаяСтрока(ТекстОшибкиСервер) Тогда
		
		Элементы.ДекорацияРазделитель.Видимость = Истина;
		Если ПустаяСтрока(ЯкорьОшибкиКлиент)
			И ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
		
			Элементы.ИнструкцияКлиент.Видимость = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЯкорьОшибки = "";
	Если Элемент.Имя = "ИнструкцияКлиент"
		И Не ПустаяСтрока(ЯкорьОшибкиКлиент) Тогда
		
		ЯкорьОшибки = ЯкорьОшибкиКлиент;
	ИначеЕсли Элемент.Имя = "ИнструкцияСервер"
		И Не ПустаяСтрока(ЯкорьОшибкиСервер) Тогда
		
		ЯкорьОшибки = ЯкорьОшибкиСервер;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ОткрытьИнструкциюПоТипичнымПроблемамПриРаботеСПрограммами(ЯкорьОшибки);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЭлементы(ТекстОшибки, ОшибкаНаСервере = Ложь)
	
	Если ОшибкаНаСервере Тогда
		ЭлементОшибка = Элементы.ОшибкаСервер;
		ЭлементИнструкция = Элементы.ИнструкцияСервер;
		ЭлементПричиныТекст = Элементы.ПричиныСерверТекст;
		ЭлементРешенияТекст = Элементы.РешенияСерверТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияСервер;
	Иначе
		ЭлементОшибка = Элементы.ОшибкаКлиент;
		ЭлементИнструкция = Элементы.ИнструкцияКлиент;
		ЭлементПричиныТекст = Элементы.ПричиныКлиентТекст;
		ЭлементРешенияТекст = Элементы.РешенияКлиентТекст;
		ГруппаПричиныИРешения = Элементы.ВозможныеПричиныИРешенияКлиент;
	КонецЕсли;
	
	ЭлементОшибка.Видимость = Не ПустаяСтрока(ТекстОшибки);
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		
		ОписаниеОшибки = ЭлектроннаяПодпись.ОшибкаПоКлассификатору(ТекстОшибки);
		ЭтоИзвестнаяОшибка = ОписаниеОшибки <> Неопределено;
		
		КлючНазначенияИспользования = КлючНазначенияИспользования
			+ ?(ЭтоИзвестнаяОшибка, "ИзвестнаяОшибка", "НеизвестнаяОшибка")
			+ ?(ОшибкаНаСервере, "Сервер", "Клиент");
		
		ГруппаПричиныИРешения.Видимость = ЭтоИзвестнаяОшибка;
		Если ЭтоИзвестнаяОшибка Тогда
			
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементИнструкция.Имя, "Заголовок", НСтр("ru = 'Подробнее'"));
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементПричиныТекст.Имя, "Заголовок", ОписаниеОшибки.Причина);
			ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				ЭлементРешенияТекст.Имя, "Заголовок", ОписаниеОшибки.Решение);
				
			Если ОшибкаНаСервере Тогда
				ЯкорьОшибкиСервер = ОписаниеОшибки.Ссылка;
			Иначе
				ЯкорьОшибкиКлиент = ОписаниеОшибки.Ссылка;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти