﻿
#Область ПроцедурыИФункцииОбщегоНазначения

// Функция - Тип цен цена включает налоги
//
// Параметры:
//  ТипЦен	 - СправочникСсылка.ТипыЦен	 - Ссылка на спавочник ТипыЦен, по которому нужно получить значение ЦенаВключаетНалоги
// 
// Возвращаемое значение:
//  ЦенаВключаетНалоги - Булево
//
&НаСервереБезКонтекста
Функция ТипЦенЦенаВключаетНалоги(ТипЦен)
	Возврат ТипЦен.ЦенаВключаетНалоги;
КонецФункции // ТипЦенЦенаВключаетНалоги()

#КонецОбласти

#Область УправлениеВнешнимВидом

&НаКлиенте
// Процедура устанавливает видимость и доступность элементов.
//
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Элементы.СтавкаНДС.Видимость = Ложь;
	Элементы.ВидПоставкиНДС.Видимость = Ложь;
	Элементы.СтавкаНСП.Видимость = Ложь;
	Элементы.СуммаВключаетНалоги.Видимость = Ложь;
	Элементы.СуммаВключаетНалоги.Доступность = Ложь;
	
	Если ДанныеУчетнойПолитики.ПлательщикНДС Тогда 
		Элементы.СтавкаНДС.Видимость 			= Истина;
		Элементы.ВидПоставкиНДС.Видимость 		= Истина; 
		Элементы.СуммаВключаетНалоги.Видимость 	= Истина;
	КонецЕсли;
	
	Если ДанныеУчетнойПолитики.ПлательщикНСП
		И Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда 
		Элементы.СтавкаНСП.Видимость = Истина;
		Элементы.СуммаВключаетНалоги.Видимость = Истина;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда 
		Элементы.СуммаВключаетНалоги.Доступность = Истина;
	КонецЕсли;	
	
	Элементы.ТипЦен.Видимость = Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем");
	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

#КонецОбласти

#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(ТекущаяДата(), Объект.Организация);
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии формы.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере формы.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ДанныеУчетнойПолитики = БухгалтерскийУчетСервер.ПолучитьДанныеУчетнойПолитикиОрганизаций(ТекущаяДата(), Объект.Организация);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда 
		Объект.ТипЦен = "";
		Объект.СуммаВключаетНалоги = Ложь;
	КонецЕсли;
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	Объект.СуммаВключаетНалоги = ТипЦенЦенаВключаетНалоги(Объект.ТипЦен);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда  
		Оповестить("МодифицированДоговораКонтрагента", МодифицированностьЭлементаНаСервере(), ЭтаФорма);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Функция МодифицированностьЭлементаНаСервере()
	Справочник = РеквизитФормыВЗначение("Объект");
	Возврат Справочник.Модифицированность()
КонецФункции

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти



