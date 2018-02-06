﻿#Область ОбработчикиСобытийФормы

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
	
	Элементы.ВариантИнтерфейса.СписокВыбора.Очистить();
	Элементы.ВариантИнтерфейса.СписокВыбора.Добавить("ИнтерфейсТакси", НСтр("ru='""Такси"" (рекомендуется)'"));
	Элементы.ВариантИнтерфейса.СписокВыбора.Добавить("ИнтерфейсВерсии82", НСтр("ru='Как в предыдущих версиях 1С:Бухгалтерии 8'"));
	
	// Значения реквизитов формы
	Если Константы.ИнтерфейсТакси.Получить() Тогда
		ВариантИнтерфейса = "ИнтерфейсТакси";
	ИначеЕсли Константы.ИнтерфейсВерсии82.Получить() Тогда
		ВариантИнтерфейса = "ИнтерфейсВерсии82";
	Иначе
		ВариантИнтерфейса = "";
	КонецЕсли;
	
	ВариантИнтерфейсаДоИзменения = ВариантИнтерфейса;
	Если ВариантИнтерфейса = "" Тогда
		ВариантИнтерфейса = "ИнтерфейсТакси";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода ВариантИнтерфейса.
//
&НаКлиенте
Процедура ВариантИнтерфейсаПриИзменении(Элемент)

	Элементы.ГруппаПерезапускКнопка.Видимость = ВариантИнтерфейсаДоИзменения <> ВариантИнтерфейса;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Перезапустить(Команда)
	
	УстановитьИнтерфейсНаСервере(ВариантИнтерфейса);
	
	ЗавершитьРаботуСистемы(Ложь, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура УстановитьИнтерфейсНаСервере(ВариантИнтерфейса)

	ОбщегоНазначенияБПСервер.УстановитьРежимКомандногоИнтерфейса(ВариантИнтерфейса);
	ХранилищеОбщихНастроек.Сохранить(ВРег("ДатаСменыИнтерфейса"),,ТекущаяДатаСеанса(),,);
	
КонецПроцедуры

#КонецОбласти
