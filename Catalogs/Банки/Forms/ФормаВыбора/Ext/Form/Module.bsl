﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СписокНайденныхБанков") Тогда
		
		РаботаСОтборамиКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ссылка", Параметры.СписокНайденныхБанков, Истина,ВидСравненияКомпоновкиДанных.ВСписке);
		Элементы.Список.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы;
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ТекстВопроса = НСтр("ru = 'Есть возможность подобрать банк из классификатора.
		|Подобрать?'");
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЭтоГруппа", Группа);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОпределитьНеобходимостьПодбораБанкаИзКлассификатора", ЭтотОбъект, ДополнительныеПараметры);
	
	ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Истина, Истина);
	ОткрытьФорму("Справочник.Банки.Форма.ФормаВыбораБанков", ПараметрыФормы, Этаформа);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
// Процедура-обработчик результата вопроса о подборе банка из классификатора
//
//
Процедура ОпределитьНеобходимостьПодбораБанкаИзКлассификатора(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = КодВозвратаДиалога.Да Тогда
		
		ПараметрыФормы = Новый Структура("РежимВыбора, ЗакрыватьПриВыборе, МножественныйВыбор", Истина, Истина, Истина);
		ОткрытьФорму("Справочник.Банки.Форма.ФормаВыбораБанков", ПараметрыФормы, Этаформа);
		
	Иначе
		
		Если ДополнительныеПараметры.ЭтоГруппа Тогда
			
			ОткрытьФорму("Справочник.Банки.ФормаГруппы", Новый Структура("ЭтоГруппа",Истина), ЭтотОбъект);
			
		Иначе
			
			ОткрытьФорму("Справочник.Банки.ФормаОбъекта");
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ОпределитьНеобходимостьПодбораБанкаИзКлассификатора()

#КонецОбласти
