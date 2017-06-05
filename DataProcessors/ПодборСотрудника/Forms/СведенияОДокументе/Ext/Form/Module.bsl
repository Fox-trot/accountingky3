﻿#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Объект, Параметры);
	ЗаполнитьНадпись(Объект.ПоказыватьУволенных);
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура заполняет декорациию
//
Процедура ЗаполнитьНадпись(ПоказыватьУволенных)
	
	Если ПоказыватьУволенных Тогда 
		Элементы.ДекорацияСодержание.Заголовок = НСтр("ru = 'Ограничений нет.'");
	Иначе 
		Элементы.ДекорацияСодержание.Заголовок = НСтр("ru = 'Доступны только НЕ уволенные сотрудники.'");
	КонецЕсли;	
	
КонецПроцедуры // ЗаполнитьНадпись()

#КонецОбласти


