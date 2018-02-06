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
	
	ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(
		Объект.Наименование,
		Объект.НаименованиеПолное,
		Объект.КодПравовойФормы);
	
	СтруктураДляПроверкиИНН = Новый Структура;
	
	СтруктураДляПроверкиИНН.Вставить("ИНН",							Объект.ИНН);
	СтруктураДляПроверкиИНН.Вставить("ЭтоЮрЛицо",					Истина);
	СтруктураДляПроверкиИНН.Вставить("ПроверитьИНН",				Истина);
	СтруктураДляПроверкиИНН.Вставить("ИННВведенКорректно",			Ложь);
	СтруктураДляПроверкиИНН.Вставить("ПустойИНН",					Ложь);

	ПроверитьКорректностьИНН(СтруктураДляПроверкиИНН, ЭтаФорма);

	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация");
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

	ОбновитьИнтерфейс = ТекущийОбъект.ЭтоНовый() И НЕ ПолучитьФункциональнуюОпцию("УчетПоНесколькимОрганизациям");
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ОбновитьИнтерфейс Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

&НаКлиенте
Процедура КодПравовойФормыПриИзменении(Элемент)
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	ФормироватьНаименованиеПолноеАвтоматически = УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(
		Объект.Наименование,
		Объект.НаименованиеПолное,
		Объект.КодПравовойФормы
	);
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксПриИзменении(Элемент)
	Если Найти(Объект.Префикс, "-") > 0 Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Нельзя в префиксе организации использовать символ ""-"".'"));
		Объект.Префикс = СтрЗаменить(Объект.Префикс, "-", "");
	КонецЕсли;
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита ИНН
//
&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	СтруктураДляПроверкиИНН.Вставить("ИНН", Объект.ИНН);
	ПроверитьКорректностьИНН(СтруктураДляПроверкиИНН, ЭтаФорма);
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойБанковскийСчетНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОсновнаяКассаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		СтандартнаяОбработка = Ложь;
		
		ТекстСообщения = НСтр("ru = 'Элемент справочника еще не записан.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиРезультатовИнтерактивныхДействий
//Код процедур и функций
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаКлиенте
Процедура УстановитьВидимостьДоступностьЭлементов()
	Элементы.НадписьПоясненияНекорректногоИНН.Видимость = НЕ СтруктураДляПроверкиИНН.ИННВведенКорректно;
КонецПроцедуры // УстановитьВидимостьДоступностьЭлементов()

// Процедура управляет информационными надписями о корректности заполнения ИНН.
// 
&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьКорректностьИНН(СтруктураПараметров, Форма)
	ВозвращеннаяСтруктура = БухгалтерскийУчетКлиентСервер.ПроверитьКорректностьИНН(СтруктураПараметров);
	
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ВозвращеннаяСтруктура);
	ЗаполнитьЗначенияСвойств(Форма, ВозвращеннаяСтруктура);
КонецПроцедуры

// Присваивает соответствующее значение переменной ФормироватьНаименованиеПолноеАвтоматически.
//
//
&НаКлиентеНаСервереБезКонтекста
Функция УстановитьФлагФормироватьНаименованиеПолноеАвтоматически(Наименование, НаименованиеПолное, КодПравовойФормы)
	Возврат (СтрШаблон("%1 ""%2""", КодПравовойФормы, Наименование) = НаименованиеПолное ИЛИ ПустаяСтрока(НаименованиеПолное));
КонецФункции // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

&НаКлиенте
// Процедура формирует полное наименование.
//
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если НЕ ФормироватьНаименованиеПолноеАвтоматически Тогда 
		Возврат;
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Объект.КодПравовойФормы) Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	Иначе
		Объект.НаименованиеПолное = СтрШаблон("%1 ""%2""", Объект.КодПравовойФормы, Объект.Наименование);
	КонецЕсли;

КонецПроцедуры // СформироватьНаименованиеПолноеАвтоматически()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
		МодульУправлениеКонтактнойИнформациейКлиент.ПриИзменении(ЭтотОбъект, Элемент);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
		МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриНажатии(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
		МодульУправлениеКонтактнойИнформациейКлиент.НачалоВыбора(ЭтотОбъект, Элемент,, СтандартнаяОбработка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
		МодульУправлениеКонтактнойИнформациейКлиент.Очистка(ЭтотОбъект, Элемент.Имя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформациейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("УправлениеКонтактнойИнформациейКлиент");
		МодульУправлениеКонтактнойИнформациейКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда.Имя);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ОбновитьКонтактнуюИнформацию(Результат)
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.КонтактнаяИнформация") Тогда
		МодульУправлениеКонтактнойИнформацией = ОбщегоНазначения.ОбщийМодуль("УправлениеКонтактнойИнформацией");
		МодульУправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	КонецЕсли;
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

#КонецОбласти
