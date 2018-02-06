﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьФункциональныеОпцииФормы();

	Если ЗначениеЗаполнено(Объект.Владелец) Тогда 
		Элементы.Владелец.ТолькоПросмотр = Истина;	
	КонецЕсли;	
	             
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПослеЗаписиНаСервере.
//
&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда  
		Оповестить("МодифицированДоговораКонтрагента", МодифицированностьЭлементаНаСервере(), ЭтаФорма);
	КонецЕсли;	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

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
Процедура ВалютаРасчетовПриИзменении(Элемент)
	Объект.Наименование = НаименованиеДоговора(Объект.ВалютаРасчетов, Объект.НомерДоговора);
КонецПроцедуры

&НаКлиенте
Процедура НомерДоговораПриИзменении(Элемент)
	Объект.Наименование = НаименованиеДоговора(Объект.ВалютаРасчетов, Объект.НомерДоговора);
КонецПроцедуры // НомерДоговораПриИзменении()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает функциональные опции формы документа.
//
&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	ОбщегоНазначенияБПКлиентСервер.УстановитьПараметрыФункциональныхОпцийФормыДокумента(ЭтаФорма, Объект.Организация, ТекущаяДатаСеанса());
КонецПроцедуры

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем") Тогда 
		Элементы.ТипЦен.Видимость = Истина;
		Элементы.ВидПоставкиНДС.Видимость = Истина;
		Элементы.СуммаВключаетНалоги.Видимость = Истина;
		Элементы.СтавкаНДС.Видимость = Истина;
		Элементы.СтавкаНСП.Видимость = Ложь;
		Элементы.СтавкаНСПУслуги.Видимость = Ложь;
	ИначеЕсли Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда	
		Элементы.ТипЦен.Видимость = Ложь;
		Элементы.ВидПоставкиНДС.Видимость = Ложь;
		Элементы.СуммаВключаетНалоги.Видимость = Ложь;
		Элементы.СтавкаНДС.Видимость = Истина;
		Элементы.СтавкаНСП.Видимость = Истина;
		Элементы.СтавкаНСПУслуги.Видимость = Истина;
	Иначе 
		Элементы.ТипЦен.Видимость = Ложь;
		Элементы.ВидПоставкиНДС.Видимость = Ложь;
		Элементы.СуммаВключаетНалоги.Видимость = Ложь;
		Элементы.СтавкаНДС.Видимость = Ложь;
		Элементы.СтавкаНСП.Видимость = Ложь;
		Элементы.СтавкаНСПУслуги.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.СуммаВключаетНалоги.Доступность = Ложь;
	Если НЕ ЗначениеЗаполнено(Объект.ТипЦен) Тогда 
		Элементы.СуммаВключаетНалоги.Доступность = Истина;
	КонецЕсли;	
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

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

&НаСервере
Функция МодифицированностьЭлементаНаСервере()
	Справочник = РеквизитФормыВЗначение("Объект");
	Возврат Справочник.Модифицированность()
КонецФункции

// Процедура составляет наименование договора.
//
&НаСервере
Функция НаименованиеДоговора(ВалютаРасчетов, НомерДоговора)
	Возврат Справочники.ДоговорыКонтрагентов.НаименованиеДоговора(ВалютаРасчетов, НомерДоговора);
КонецФункции // НаименованиеДоговора()

// Функция проверяет возможность изменения реквизитов договора.
//
&НаСервереБезКонтекста
Функция ОтказИзменитьРеквизитыДоговора(Ссылка) 
	
	Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ХозрасчетныйСубконто.Период КАК Период,
		|	ХозрасчетныйСубконто.Регистратор КАК Регистратор,
		|	ХозрасчетныйСубконто.Значение КАК Значение
		|ИЗ
		|	РегистрБухгалтерии.Хозрасчетный.Субконто КАК ХозрасчетныйСубконто
		|ГДЕ
		|	ХозрасчетныйСубконто.Значение = &Ссылка");
	Запрос.УстановитьПараметр("Ссылка", ?(ЗначениеЗаполнено(Ссылка), Ссылка, Неопределено));
	
	Результат = Запрос.Выполнить();
	
	Возврат НЕ Результат.Пустой();
	
КонецФункции // ОтказИзменитьРеквизитыДоговора()

#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий

&НаКлиенте
Процедура РазрешитьРедактированиеРеквизитовОбъекта(Результат, ДополнительныеПараметры) Экспорт
	
	Если ОтказИзменитьРеквизитыДоговора(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'В базе есть движения по этому договору. Изменение ключевых реквизитов запрещено.'"));
		Возврат;
	КонецЕсли;
	
	РазблокируемыеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.Реквизиты(ЭтотОбъект);
	ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтотОбъект,
		РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	//ЗапретРедактированияРеквизитовОбъектовКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтотОбъект, Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъекта", ЭтотОбъект));
	ЗаблокированныеРеквизиты = ЗапретРедактированияРеквизитовОбъектовКлиент.Реквизиты(ЭтотОбъект);
	
	СинонимыРеквизитов = Новый Массив;
	
	Для Каждого ОписаниеРеквизита Из ЭтотОбъект.ПараметрыЗапретаРедактированияРеквизитов Цикл
		Если ЗаблокированныеРеквизиты.Найти(ОписаниеРеквизита.ИмяРеквизита) <> Неопределено Тогда
			СинонимыРеквизитов.Добавить(ОписаниеРеквизита.Представление);
		КонецЕсли;
	КонецЦикла;
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Объект.Ссылка);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", ЭтотОбъект);
	ДополнительныеПараметры.Вставить("ЗаблокированныеРеквизиты", ЗаблокированныеРеквизиты);
	ДополнительныеПараметры.Вставить("ОбработкаПродолжения", Неопределено);
	
	ЗапретРедактированияРеквизитовОбъектовКлиент.ПроверитьСсылкиНаОбъект(
		Новый ОписаниеОповещения("РазрешитьРедактированиеРеквизитовОбъекта",
			ЭтотОбъект, ДополнительныеПараметры),
		МассивСсылок,
		СинонимыРеквизитов);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти



