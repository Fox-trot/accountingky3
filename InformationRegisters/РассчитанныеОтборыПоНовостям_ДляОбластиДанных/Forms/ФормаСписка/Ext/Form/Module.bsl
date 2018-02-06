﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьОтборы(Команда)

	// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
	// В разделенном сеансе будут пересчитаны только пользовательские отборы и общие для области данных.
	ОбработкаНовостейВызовСервера.ОптимизироватьОтборыПоНовостям(Неопределено);

	// Пересчитать отборы.
	ОбработкаНовостейВызовСервера.ПересчитатьОтборыПоНовостям_Общие(Неопределено);

	ОбработкаНовостейВызовСервера.ПересчитатьОтборыПоНовостям_ДляОбластиДанных(Неопределено);

КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьОтобразитьПодсказку(Команда)

	Если Элементы.ДекорацияПодсказка.Высота = 1 Тогда
		Элементы.ДекорацияПодсказка.Высота = 5;
	Иначе
		Элементы.ДекорацияПодсказка.Высота = 1;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
