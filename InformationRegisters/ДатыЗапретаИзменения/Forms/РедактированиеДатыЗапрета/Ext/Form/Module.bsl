﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПользовательПредставление = Параметры.ПользовательПредставление;
	РазделПредставление       = Параметры.РазделПредставление;
	Объект                    = Параметры.Объект;
	ОписаниеДатыЗапрета       = Параметры.ОписаниеДатыЗапрета;
	КоличествоДнейРазрешения  = Параметры.КоличествоДнейРазрешения;
	ДатаЗапрета               = Параметры.ДатаЗапрета;
	
	РазрешитьИзменениеДанныхДоДатыЗапрета = КоличествоДнейРазрешения > 0;
	
	Если Не ЗначениеЗаполнено(РазделПредставление)
	   И Не ЗначениеЗаполнено(Объект) Тогда
	   
		Элементы.РазделПредставление.Видимость = Ложь;
		Элементы.ОбъектПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезРазделаИОбъекта");
		
	ИначеЕсли Не ЗначениеЗаполнено(РазделПредставление) Тогда
		Элементы.РазделПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезРаздела");
	
	ИначеЕсли Не ЗначениеЗаполнено(Объект) Тогда
		Элементы.ОбъектПредставление.Видимость = Ложь;
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "БезОбъекта");
	ИначеЕсли ЗначениеЗаполнено(Объект) Тогда	
		Если ТипЗнч(Объект) = Тип("Строка") Тогда
			Элементы.ОбъектПредставление.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
			Элементы.ОбъектПредставление.Гиперссылка = Ложь;
		Иначе	
			ПредставлениеОбъекта = Объект.Метаданные().ПредставлениеОбъекта;
			Если ПустаяСтрока(ПредставлениеОбъекта) Тогда
				ПредставлениеОбъекта = Объект.Метаданные().Представление();
			КонецЕсли;
			Элементы.ОбъектПредставление.Заголовок = ПредставлениеОбъекта;
		КонецЕсли;
	КонецЕсли;
	
	Если ОписаниеДатыЗапрета = "" Тогда // не установлен
		ОписаниеДатыЗапрета = "ПроизвольнаяДата";
	КонецЕсли;
	
	// Кэширование текущей даты на сервере.
	НачалоДня = ТекущаяДатаСеанса();
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
	Если ОписаниеДатыЗапрета = "ПроизвольнаяДата" Тогда	
		ТекущийЭлемент = Элементы.ДатаЗапретаПростойРежим;
	КонецЕсли;
	 
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОповеститьОВыборе(ВозвращаемоеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

////////////////////////////////////////////////////////////////////////////////
// Одинаковые обработчики событий форм ДатыЗапретаИзменения и РедактированиеДатыЗапрета.

&НаКлиенте
Процедура ОписаниеДатыЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОписаниеДатыЗапретаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОписаниеДатыЗапрета = Элементы.ОписаниеДатыЗапрета.СписокВыбора[0].Значение;
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьИзменениеДанныхДоДатыЗапретаПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейРазрешенияПриИзменении(Элемент)
	
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура КоличествоДнейРазрешенияАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоДнейРазрешения = Текст;
	ДатыЗапретаИзмененияСлужебныйКлиентСервер.ОбщаяДатаЗапретаСОписаниемПриИзменении(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(, Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура БольшеВозможностейНажатие(Элемент)
	
	Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Элементы.РасширенныйРежим;
	
КонецПроцедуры

&НаКлиенте
Процедура МеньшеВозможностейНажатие(Элемент)
	
	Элементы.ГруппаРежимыРаботы.ТекущаяСтраница = Элементы.ПростойРежим;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ОписаниеДатыЗапрета",      ОписаниеДатыЗапрета);
	ВозвращаемоеЗначение.Вставить("КоличествоДнейРазрешения", КоличествоДнейРазрешения);
	ВозвращаемоеЗначение.Вставить("ДатаЗапрета",              ДатаЗапрета);
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти
