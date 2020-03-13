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
	
	Заголовок = Параметры.ЗаголовокФормы;
	
	ШиринаЗаголовка = СтрДлина(Заголовок);
	Если ШиринаЗаголовка > 80 Тогда
		ШиринаЗаголовка = 80;
	КонецЕсли;
	Если ШиринаЗаголовка > 35 Тогда
		Ширина = ШиринаЗаголовка;
	КонецЕсли;
	
	ЭтоПолноправныйПользователь = Пользователи.ЭтоПолноправныйПользователь(,, Ложь);
	
	ОшибкаНаКлиенте = Параметры.ОшибкаНаКлиенте;
	ОшибкаНаСервере = Параметры.ОшибкаНаСервере;
	
	Если ЗначениеЗаполнено(ОшибкаНаКлиенте)
	   И ЗначениеЗаполнено(ОшибкаНаСервере) Тогда
		
		ОписаниеОшибки =
			  НСтр("ru = 'НА СЕРВЕРЕ:'")
			+ Символы.ПС + Символы.ПС + ОшибкаНаСервере.ОписаниеОшибки
			+ Символы.ПС + Символы.ПС
			+ НСтр("ru = 'НА КОМПЬЮТЕРЕ:'")
			+ Символы.ПС + Символы.ПС + ОшибкаНаКлиенте.ОписаниеОшибки;
	Иначе
		ОписаниеОшибки = ОшибкаНаКлиенте.ОписаниеОшибки;
	КонецЕсли;
	
	ОписаниеОшибки = СокрЛП(ОписаниеОшибки);
	Элементы.ОписаниеОшибки.Заголовок = ОписаниеОшибки;
	
	ПоказатьИнструкцию                = Параметры.ПоказатьИнструкцию;
	ПоказатьПереходКНастройкеПрограмм = Параметры.ПоказатьПереходКНастройкеПрограмм;
	ПоказатьУстановкуРасширения       = Параметры.ПоказатьУстановкуРасширения;
	
	ОпределитьВозможности(ПоказатьИнструкцию, ПоказатьПереходКНастройкеПрограмм, ПоказатьУстановкуРасширения,
		ОшибкаНаКлиенте, ЭтоПолноправныйПользователь);
	
	ОпределитьВозможности(ПоказатьИнструкцию, ПоказатьПереходКНастройкеПрограмм, ПоказатьУстановкуРасширения,
		ОшибкаНаСервере, ЭтоПолноправныйПользователь);
	
	Если Не ПоказатьИнструкцию Тогда
		Элементы.Инструкция.Видимость = Ложь;
	КонецЕсли;
	
	ПоказатьУстановкуРасширения = ПоказатьУстановкуРасширения И Не Параметры.РасширениеПодключено;
	
	Если Не ПоказатьУстановкуРасширения Тогда
		Элементы.ФормаУстановитьРасширение.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ПоказатьПереходКНастройкеПрограмм Тогда
		Элементы.ФормаПерейтиКНастройкеПрограмм.Видимость = Ложь;
	КонецЕсли;
	
	СброситьРазмерыИПоложениеОкна();
	
	Если ТипЗнч(Параметры.НеподписанныеДанные) = Тип("Структура") Тогда
		ЭлектроннаяПодписьСлужебный.ЗарегистрироватьПодписаниеДанныхВЖурнале(
			Параметры.НеподписанныеДанные, ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнструкцияНажатие(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ОткрытьИнструкциюПоРаботеСПрограммами();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиКНастройкеПрограмм(Команда)
	
	Закрыть();
	ЭлектроннаяПодписьКлиент.ОткрытьНастройкиЭлектроннойПодписиИШифрования("Программы");
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРасширение(Команда)
	
	ЭлектроннаяПодписьКлиент.УстановитьРасширение(Истина);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьВБуферОбмена(Команда)
	
	Строка = Элементы.ОписаниеОшибки.Заголовок;
	ПоказатьВводСтроки(Новый ОписаниеОповещения("СкопироватьВБуферОбменаЗавершение", ЭтотОбъект),
		Строка, НСтр("ru = 'Текст ошибки для копирования'"),, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СкопироватьВБуферОбменаЗавершение(Результат, Контекст) Экспорт
	
	Результат = "";
	
КонецПроцедуры

&НаСервере
Процедура СброситьРазмерыИПоложениеОкна()
	
	ИмяПользователя = ПользователиИнформационнойБазы.ТекущийПользователь().Имя;
	
	Если ПравоДоступа("СохранениеДанныхПользователя", Метаданные) Тогда
		ХранилищеСистемныхНастроек.Удалить("ОбщаяФорма.Вопрос", "", ИмяПользователя);
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = Строка(Новый УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможности(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь)
	
	ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь);
	
	Если Не Ошибка.Свойство("Ошибки") Или ТипЗнч(Ошибка.Ошибки) <> Тип("Массив") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТекущаяОшибка Из Ошибка.Ошибки Цикл
		ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, ТекущаяОшибка, ЭтоПолноправныйПользователь);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьВозможностиПоСвойствам(Инструкция, НастройкаПрограмм, Расширение, Ошибка, ЭтоПолноправныйПользователь)
	
	Если Ошибка.Свойство("НастройкаПрограмм") И Ошибка.НастройкаПрограмм = Истина Тогда
		НастройкаПрограмм = ЭтоПолноправныйПользователь
			Или Не Ошибка.Свойство("КАдминистратору")
			Или Ошибка.КАдминистратору <> Истина;
	КонецЕсли;
	
	Если Ошибка.Свойство("Инструкция") И Ошибка.Инструкция = Истина Тогда
		Инструкция = Истина;
	КонецЕсли;
	
	Если Ошибка.Свойство("Расширение") И Ошибка.Расширение = Истина Тогда
		Расширение = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
