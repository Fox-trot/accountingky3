﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СписокПараметров           = Параметры.СписокПараметров;
	// Наследуем реквизит формы отчета ОписанияТиповВидовСубконто, для обработки в процедуре
	// БухгалтерскиеОтчетыКлиент.ОтборОбработатьВыборЗначения.
	ОписанияТиповВидовСубконто = Параметры.ОписанияТиповВидовСубконто;
	Значение                   = Параметры.Значение;
	
	Если Параметры.ТипПоля <> Неопределено Тогда
		
		Список.ТипЗначения = Параметры.ТипПоля;
		
	Иначе
		Отказ = Истина;
	КонецЕсли;
	
	Если ТипЗнч(Значение) = Тип("СписокЗначений") Тогда
		
		Список.ЗагрузитьЗначения(Значение.ВыгрузитьЗначения());
		
	ИначеЕсли ЗначениеЗаполнено(Значение) Тогда
		
		Список.Добавить(Значение);
		
	КонецЕсли;
	
	НестандартныйОтбор = Ложь;
	Если Список.ТипЗначения.Типы().Количество() > 0 Тогда
		НестандартныйОтбор = БухгалтерскиеОтчеты.ЭтоТипЭлементаСоСложнымПодбором(Список.ТипЗначения.Типы()[0]);
	КонецЕсли;
	
	Элементы.НестандартныйПодбор.Видимость = НестандартныйОтбор;
	Элементы.Подбор.Видимость = Не НестандартныйОтбор;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСписка

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	СтандартнаяОбработка = Истина;
	БухгалтерскиеОтчетыКлиент.ОтборОбработатьВыборЗначения(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Значение,
		СписокПараметров,
		Список.ТипЗначения,
		ФлагПодбора);
	
	ФлагПодбора = Ложь;
	Если НЕ СтандартнаяОбработка Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	БухгалтерскиеОтчетыКлиент.ОтборОбработатьВыборЗначения(
		ЭтотОбъект,
		Элемент,
		СтандартнаяОбработка,
		Элементы.Список.ТекущиеДанные.Значение,
		СписокПараметров,
		Список.ТипЗначения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подбор(Команда)
	
	ФлагПодбора = Истина;
	Элементы.Список.ДобавитьСтроку();
	
КонецПроцедуры

&НаКлиенте
Процедура Готово(Команда)
	Закрыть(Список);
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти