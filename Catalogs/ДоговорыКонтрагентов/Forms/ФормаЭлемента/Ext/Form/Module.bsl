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

	УстановитьФункциональныеОпцииФормы();

	Если ЗначениеЗаполнено(Объект.Владелец) Тогда 
		Элементы.Владелец.ТолькоПросмотр = Истина;	
	КонецЕсли;	
	
	СрокОплатыПокупателей = Константы.СрокОплатыПокупателей.Получить();
	СрокОплатыПоставщикам = Константы.СрокОплатыПоставщикам.Получить();

	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();

	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом 
	
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

// Процедура - обработчик события ПриИзменении поля ввода ВидДоговора.
//
&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ТипЦен.
//
&НаКлиенте
Процедура ТипЦенПриИзменении(Элемент)
	Объект.СуммаВключаетНалоги = ТипЦенЦенаВключаетНалоги(Объект.ТипЦен);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода ВалютаРасчетов.
//
&НаКлиенте
Процедура ВалютаРасчетовПриИзменении(Элемент)
	Объект.Наименование = НаименованиеДоговора(Объект.ВалютаРасчетов, Объект.НомерДоговора, Объект.ДатаДоговора);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода НомерДоговора.
//
&НаКлиенте
Процедура НомерДоговораПриИзменении(Элемент)
	Объект.Наименование = НаименованиеДоговора(Объект.ВалютаРасчетов, Объект.НомерДоговора, Объект.ДатаДоговора);
КонецПроцедуры // НомерДоговораПриИзменении()

&НаКлиенте
Процедура ДатаДоговораПриИзменении(Элемент)
	Объект.Наименование = НаименованиеДоговора(Объект.ВалютаРасчетов, Объект.НомерДоговора, Объект.ДатаДоговора);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении флага УстановленСрокОплаты.
//
&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении(Элемент)

	Если Объект.УстановленСрокОплаты Тогда
		Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем") Тогда
			Объект.СрокОплаты = СрокОплатыПокупателей;
		ИначеЕсли Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") Тогда
			Объект.СрокОплаты = СрокОплатыПоставщикам;
		КонецЕсли;
	Иначе
		СрокОплаты = 0;
	КонецЕсли;
	
	УстановитьВидимостьДоступностьЭлементов();

КонецПроцедуры

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
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	
	Если Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПокупателем Тогда 
		Элементы.ТипЦен.Видимость = Истина;
		Элементы.ВидПоставкиНДС.Видимость = Истина;
		Элементы.СуммаВключаетНалоги.Видимость = Истина;
		Элементы.СтавкаНДС.Видимость = Истина;
	Иначе 
		Элементы.ТипЦен.Видимость = Ложь;
		Элементы.ВидПоставкиНДС.Видимость = Ложь;
		Элементы.СуммаВключаетНалоги.Видимость = Ложь;
		Элементы.СтавкаНДС.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ГруппаСрокОплаты.Видимость = Объект.ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.Прочее;
	Элементы.СрокОплаты.Видимость = Объект.УстановленСрокОплаты;
КонецПроцедуры 

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
&НаСервереБезКонтекста
Функция НаименованиеДоговора(ВалютаРасчетов, НомерДоговора, ДатаДоговора)
	Возврат Справочники.ДоговорыКонтрагентов.НаименованиеДоговора(ВалютаРасчетов, НомерДоговора, ДатаДоговора);
КонецФункции

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



