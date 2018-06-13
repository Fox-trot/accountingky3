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
	
	ЗаполнитьСписокВыбораБанков();
	Режим = "Выгрузка";
	Объект.ДатаНачала = НачалоДня(ТекущаяДатаСеанса());
	Объект.ДатаОкончания = КонецДня(ТекущаяДатаСеанса());
	Объект.Организация = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьЗначениеНастройки("ОсновнаяОрганизация");
	Объект.БанковскийСчет = Объект.Организация.ОсновнойБанковскийСчет;
	
	ПоискБанка();

	УстановитьПараметрыДинамическихСписков();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьДополнительныеСведения();
КонецПроцедуры

// Процедура - обработчик события ОбработкаПроверкиЗаполненияНаСервере
//
&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Режим = "Выгрузка"	Тогда 
		МассивНепроверяемыхРеквизитов.Добавить("ИмяФайлаЗагрузки");
	Иначе 
		МассивНепроверяемыхРеквизитов.Добавить("ИмяКаталога");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаНачала");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаОкончания");
	КонецЕсли;	
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Режим.
//
&НаКлиенте
Процедура РежимПриИзменении(Элемент)
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита Банк
//
&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	ОбновитьДополнительныеСведения();
	
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора реквизита ИмяФайлаВыгрузки
//
&НаКлиенте
Процедура ИмяФайлаВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события НачалоВыбора реквизита ИмяФайлаЗагрузки
//
&НаКлиенте
Процедура ИмяФайлаЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОбработатьНачалоВыбораФайла(СтандартнаяОбработка);
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита ДатаНачала
//
&НаКлиенте
Процедура ДатаНачалаПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита ДатаОкончания
//
&НаКлиенте
Процедура ДатаОкончанияПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
КонецПроцедуры

// Процедура - обработчик события ПриИзменении реквизита БанковскийСчет
//
&НаКлиенте
Процедура БанковскийСчетПриИзменении(Элемент)
	УстановитьПараметрыДинамическихСписков();
	
	ПоискБанка();	
	ОбновитьДополнительныеСведения();
	// Установить видимость и доступность элементов формы
	УстановитьВидимостьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФайлВыгрузки(Неопределено);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	Если ТребуетсяНастройкаАвторизацияИнтернетПоддержки() Тогда
		ТекстВопроса = НСтр("ru='Для выгрузки данных
			|необходимо подключиться к Интернет-поддержке пользователей.
			|Подключиться сейчас?'");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПриПодключенииИнтернетПоддержки", ЭтотОбъект);
		Кнопки = Новый СписокЗначений;
		Кнопки.Добавить(КодВозвратаДиалога.Да, НСтр("ru = 'Подключиться'"));
		Кнопки.Добавить(КодВозвратаДиалога.Отмена);
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, Кнопки);
	Иначе
		ПродолжитьВыгрузку();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает видимость и доступность элементов.
//
&НаСервере
Процедура УстановитьВидимостьДоступностьЭлементов()
	Если Режим = "Выгрузка"	Тогда 
		Элементы.СписокППИ.Видимость = Истина;	
		Элементы.ИмяФайлаВыгрузки.Видимость = Истина;	
		Элементы.ИмяКаталога.Видимость = Истина;	
		Элементы.ДатаНачала.Видимость = Истина;	
		Элементы.ДатаОкончания.Видимость = Истина;	
		
		Элементы.ИмяФайлаЗагрузки.Видимость = Ложь;	
		Элементы.ТаблицаДокументыКСозданию.Видимость = Ложь;	
	Иначе 
		Элементы.СписокППИ.Видимость = Ложь;	
		Элементы.ИмяФайлаВыгрузки.Видимость = Ложь;	
		Элементы.ИмяКаталога.Видимость = Ложь;	
		Элементы.ДатаНачала.Видимость = Ложь;	
		Элементы.ДатаОкончания.Видимость = Ложь;	
		
		Элементы.ИмяФайлаЗагрузки.Видимость = Истина;	
		Элементы.ТаблицаДокументыКСозданию.Видимость = Истина;	
	КонецЕсли;
	
	Если Банк = "ЗАО ""Демир Кыргыз Интернэшнл Банк""" Тогда 
		Элементы.ОтправкаГроссом.Видимость = Истина;
	Иначе 
		Элементы.ОтправкаГроссом.Видимость = Ложь;
	КонецЕсли;	
КонецПроцедуры 

// Процедура устанавливает значения параметров динамических списков 
//
&НаСервере
Процедура УстановитьПараметрыДинамическихСписков()
	
	МассивСписков = Новый Массив;
	МассивСписков.Добавить(СписокППИ);
	
	Для Каждого ДинамическийСписок Из МассивСписков Цикл
		Для Каждого ПараметрСписка Из ДинамическийСписок.Параметры.Элементы Цикл
			ЗначениеРеквизитаОбъекта = Неопределено;
			Если Объект.Свойство(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта) Тогда
				ДинамическийСписок.Параметры.УстановитьЗначениеПараметра(ПараметрСписка.Параметр, ЗначениеРеквизитаОбъекта);
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры // УстановитьПараметрыДинамическихСписков()

&НаСервере
Процедура ПоискБанка()
	Если Объект.БанковскийСчет.Пустая() Тогда 
		Банк = "";
		Возврат;
	КонецЕсли;	
	
	БИКБанка = Объект.БанковскийСчет.Банк.Код;
	ПриведенныйБИКБанка = Лев(БИКБанка, 3) + "001";
	
	// Поиск по классификатору.
	КлассификаторXML = Обработки.ВыгрузкаЗагрузкаПлатежныхПоручений.ПолучитьМакет("СписокБанков").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	МассивСтрок = КлассификаторТаблица.НайтиСтроки(Новый Структура("БИК", ПриведенныйБИКБанка));
	
	Если НЕ МассивСтрок.Количество() = 0 Тогда 
		Банк = МассивСтрок[0].Наименование;
	КонецЕсли;	

КонецПроцедуры // ПоискБанка()

&НаСервере
Функция ТребуетсяНастройкаАвторизацияИнтернетПоддержки()
	Если ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		МодульИнтернетПоддержкаПользователей = ОбщегоНазначения.ОбщийМодуль("ИнтернетПоддержкаПользователей");
		ДанныеАутентификации = МодульИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
		Возврат Не (ДанныеАутентификации <> Неопределено
			И ЗначениеЗаполнено(ДанныеАутентификации.Логин)
			И ЗначениеЗаполнено(ДанныеАутентификации.Пароль));
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПриПодключенииИнтернетПоддержки(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПодключенияИнтернетПоддержки", ЭтотОбъект, ДополнительныеПараметры);
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОписаниеОповещения, ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеПодключенияИнтернетПоддержки(Результат, ДополнительныеПараметры) Экспорт
	Если Не (ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)
		И ЗначениеЗаполнено(Результат.Пароль)) Тогда
		Возврат;
	КонецЕсли;
	ПродолжитьВыгрузку();
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыгрузку()

	ИмяФайлаВыгрузки = "";
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат
	КонецЕсли;	

	Отказ = Ложь;
	
	Если Режим = "Выгрузка" Тогда 
		Если Объект.ДатаНачала > Объект.ДатаОкончания Тогда
			ТекстСообщения = НСтр("ru = 'Дата начала периода не может быть больше даты окончания периода.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.ДатаНачала",, Отказ);
		КонецЕсли;

		НайденныеСтроки = СписокБанков.НайтиСтроки(Новый Структура("Наименование", Банк));
		
		Если НайденныеСтроки.Количество() = 0 Тогда 
			ТекстСообщения = НСтр("ru = 'Выберете банк из списка.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Банк",, Отказ);
		КонецЕсли;	
		
		Если Банк = "ОАО ""Оптима Банк""" Тогда 
			АдресВоВременномХранилище = СформироватьНаСервереОптимаБанк();
		ИначеЕсли Банк = "ЗАО ""Демир Кыргыз Интернэшнл Банк""" Тогда 
			АдресВоВременномХранилище = СформироватьНаСервереДемирКыргызИнтернэшнлБанк();
		Иначе 
			ТекстСообщения = НСтр("ru = 'Для выбранного банка не предусмотрено формирование файлов.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Банк",, Отказ);
		КонецЕсли;

		Если Отказ Тогда 
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(АдресВоВременномХранилище) Тогда
			ИмяФайлаВыгрузки = ИмяКаталога + "\" + Формат(ТекущаяДата(),"ДФ=yyyyMMddhhmmss" ) + ".txt";

			ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
			ДвоичныеДанные.Записать(ИмяФайлаВыгрузки);
			
			ТекстОповещения = НСтр("ru = 'Файл успешно сформирован'");
			ПоказатьОповещениеПользователя(ТекстОповещения, Новый ОписаниеОповещения("ОткрытьФайлВыгрузки", ЭтотОбъект), ИмяФайлаВыгрузки, БиблиотекаКартинок.Информация32);
		КонецЕсли;
	Иначе 
		ПрочитатьНаКлиенте();
	КонецЕсли;	

КонецПроцедуры // ПродолжитьВыгрузку()

&НаКлиенте
Процедура ОткрытьФайлВыгрузки(ДополнительныеПараметры) Экспорт
	Если ЗначениеЗаполнено(ИмяФайлаВыгрузки) Тогда 
		ЗапуститьПриложение(ИмяФайлаВыгрузки);
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораБанков()
	КлассификаторXML = Обработки.ВыгрузкаЗагрузкаПлатежныхПоручений.ПолучитьМакет("СписокБанков").ПолучитьТекст();
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(КлассификаторXML).Данные;
	
	СписокБанков.Очистить();
	Элементы.Банк.СписокВыбора.Очистить();
	
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл 
		НоваяСтрокаТаблицыЗначений = СписокБанков.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицыЗначений, СтрокаТаблицыЗначений);
		
		Элементы.Банк.СписокВыбора.Добавить(СтрокаТаблицыЗначений.Наименование);
	КонецЦикла;

КонецПроцедуры // ЗаполнитьСписокВыбораБанков()

&НаКлиенте
Процедура ОбработатьНачалоВыбораФайла(СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если Режим = "Выгрузка" Тогда 
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогВыбораФайла.МножественныйВыбор = Ложь;
		ДиалогВыбораФайла.Заголовок = Нстр("ru = 'Укажите каталог выгрузки'");
		ДиалогВыбораФайла.Каталог = ИмяФайлаВыгрузки;
		
		Если ДиалогВыбораФайла.Выбрать() Тогда
			ИмяКаталога = ДиалогВыбораФайла.Каталог;
		КонецЕсли;
	Иначе 
		ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ДиалогВыбораФайла.МножественныйВыбор = Ложь;
		ДиалогВыбораФайла.Заголовок = Нстр("ru = 'Укажите файл для импорта данных'");
		Каталог = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ИмяФайлаЗагрузки);
		ДиалогВыбораФайла.Каталог = Каталог.Путь;
		Фильтр = НСтр("ru = 'eXtensible Markup Language (*.xml)|*.xml'");
		ДиалогВыбораФайла.Фильтр = Фильтр;
		
		Если ДиалогВыбораФайла.Выбрать() Тогда
			ИмяФайлаЗагрузки = ДиалогВыбораФайла.ПолноеИмяФайла;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДополнительныеСведения()

	Адрес = "";
	ФИОРуководителя = "";
	ЭлПочта = "";
	КоличествоФилиалов = "";
	ИмяФайлаВыгрузки = "";

	НайденныеСтроки = СписокБанков.НайтиСтроки(Новый Структура("Наименование", Банк));
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
		Адрес = НайденнаяСтрока.Адрес;
		ФИОРуководителя = НайденнаяСтрока.ФИОРуководителя;
		ЭлПочта = НайденнаяСтрока.ЭлПочта;
		КоличествоФилиалов = НайденнаяСтрока.КоличествоФилиалов;
	КонецЦикла;	

КонецПроцедуры // ОбновитьДополнительныеСведения()

&НаСервере
Функция СформироватьНаСервереОптимаБанк()
	
	// Получение данных
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлатежноеПоручениеИсходящее.Номер КАК Номер,
		|	ПлатежноеПоручениеИсходящее.Дата КАК Дата,
		|	ПлатежноеПоручениеИсходящее.СуммаДокумента КАК Сумма,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.НомерСчета КАК ПлательщикСчет,
		|	ПлатежноеПоручениеИсходящее.Организация.ИНН КАК ПлательщикИНН,
		|	ПлатежноеПоручениеИсходящее.Организация.НаименованиеПолное КАК Плательщик1,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.Банк.Код КАК ПлательщикБИК,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.НомерСчета КАК ПолучательСчет,
		|	ПлатежноеПоручениеИсходящее.Контрагент.ИНН КАК ПолучательИНН,
		|	ПлатежноеПоручениеИсходящее.Контрагент.НаименованиеПолное КАК Получатель1,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.Банк.Код КАК ПолучательБИК,
		|	ПлатежноеПоручениеИсходящее.Дата КАК СрокПлатежа,
		|	ПлатежноеПоручениеИсходящее.НазначениеПлатежа КАК НазначениеПлатежа,
		|	ПлатежноеПоручениеИсходящее.КодПлатежа.Код КАК КодПлатежа
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
		|ГДЕ
		|	ПлатежноеПоручениеИсходящее.Проведен
		|	И ПлатежноеПоручениеИсходящее.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ПлатежноеПоручениеИсходящее.БанковскийСчет = &БанковскийСчет
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер";
	Запрос.УстановитьПараметр("НачалоПериода", Объект.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("БанковскийСчет", Объект.БанковскийСчет);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		ТекстСообщения = НСтр("ru = 'За указанный период нет данных для формирования файла.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;	
	
	ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	Текст = Новый ЗаписьТекста(ИмяФайла, "windows-1251");
	
	Текст.ЗаписатьСтроку("1CClientBankExchange");
	Текст.ЗаписатьСтроку("ВерсияФормата=1.01");
	Текст.ЗаписатьСтроку("Кодировка=Windows");

	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Текст.ЗаписатьСтроку("СекцияДокумент=Платежное поручение");	

		Текст.ЗаписатьСтроку("Номер=" 				+ ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДетальныеЗаписи.Номер));
		Текст.ЗаписатьСтроку("Дата=" 				+ Формат(ВыборкаДетальныеЗаписи.Дата, "ДФ=dd.MM.yyyy"));
		Текст.ЗаписатьСтроку("Сумма=" 				+ Формат(ВыборкаДетальныеЗаписи.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.; ЧГ=0"));
		
		Текст.ЗаписатьСтроку("ПлательщикСчет=" 		+ ВыборкаДетальныеЗаписи.ПлательщикСчет);
		Текст.ЗаписатьСтроку("ПлательщикИНН=" 		+ ВыборкаДетальныеЗаписи.ПлательщикИНН);
		Текст.ЗаписатьСтроку("Плательщик1=" 		+ ВыборкаДетальныеЗаписи.Плательщик1);
		Текст.ЗаписатьСтроку("ПлательщикБИК=" 		+ ВыборкаДетальныеЗаписи.ПлательщикБИК);
		
		Текст.ЗаписатьСтроку("ПолучательСчет=" 		+ ВыборкаДетальныеЗаписи.ПолучательСчет);
		Текст.ЗаписатьСтроку("ПолучательИНН=" 		+ ВыборкаДетальныеЗаписи.ПолучательИНН);
		Текст.ЗаписатьСтроку("Получатель1=" 		+ ВыборкаДетальныеЗаписи.Получатель1);
		Текст.ЗаписатьСтроку("ПолучательБИК=" 		+ ВыборкаДетальныеЗаписи.ПолучательБИК);
		
		Текст.ЗаписатьСтроку("ВидОплаты=01");
		Текст.ЗаписатьСтроку("ВидПлатежа=108");
		Текст.ЗаписатьСтроку("Очередность=6");
		
		Текст.ЗаписатьСтроку("СрокПлатежа=" 		+ Формат(ВыборкаДетальныеЗаписи.Дата, "ДФ=dd.MM.yyyy"));
		Текст.ЗаписатьСтроку("НазначениеПлатежа=" 	+ ВыборкаДетальныеЗаписи.НазначениеПлатежа);
		Текст.ЗаписатьСтроку("КодПлатежа=" 			+ ВыборкаДетальныеЗаписи.КодПлатежа);
		Текст.ЗаписатьСтроку("КонецДокумента");
	КонецЦикла;
	
	Текст.ЗаписатьСтроку("КонецФайла");

	Текст.Закрыть();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
	
	УдалитьФайлы(ИмяФайла);
	Возврат АдресВоВременномХранилище;
КонецФункции

&НаСервере
Функция СформироватьНаСервереДемирКыргызИнтернэшнлБанк()
	
	// Получение данных
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПлатежноеПоручениеИсходящее.Номер КАК Номер,
		|	ПлатежноеПоручениеИсходящее.Дата КАК Дата,
		// Данные организации
		|	ПлатежноеПоручениеИсходящее.Организация.КодПоОКПО КАК ОрганизацияОКПО,
		|	ПлатежноеПоручениеИсходящее.Организация.ИНН КАК ОрганизацияИНН,
		|	ПлатежноеПоручениеИсходящее.Организация.РегНомерСоцФонда КАК ОрганизацияРегНомерСоцФонда,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.Банк.Код КАК БанковскийСчетБанкКод,
		|	ПлатежноеПоручениеИсходящее.Организация.НаименованиеПолное КАК ОрганизацияНаименованиеПолное,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.НомерСчета КАК БанковскийСчетНомерСчета,
		|	ПлатежноеПоручениеИсходящее.БанковскийСчет.Банк.Наименование КАК БанковскийСчетБанкНаименование,
		// Данные Контрагента
		|	ЕСТЬNULL(ПлатежноеПоручениеИсходящее.Контрагент.НаименованиеПолное, """") КАК КонтрагентНаименованиеПолное,
		|	ЕСТЬNULL(ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.НомерСчета, """") КАК БанковскийСчетПолучателяНомерСчета,
		|	ЕСТЬNULL(ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.Банк.Код, """") КАК БанковскийСчетПолучателяБанкКод,
		|	ЕСТЬNULL(ПлатежноеПоручениеИсходящее.БанковскийСчетПолучателя.Банк.Наименование, """") КАК БанковскийСчетПолучателяБанкНаименование,
		// Данные документа
		|	ПлатежноеПоручениеИсходящее.СуммаДокумента КАК СуммаДокумента,
		|	ПлатежноеПоручениеИсходящее.ВалютаДокумента КАК ВалютаДокумента,
		|	ПлатежноеПоручениеИсходящее.КодПлатежа КАК КодПлатежаКод,
		|	ПлатежноеПоручениеИсходящее.ВалютаДокумента.Наименование КАК ВалютаДокументаНаименование,
		|	выразить(ПлатежноеПоручениеИсходящее.НазначениеПлатежа как строка(700)) КАК НазначениеПлатежа
		|ИЗ
		|	Документ.ПлатежноеПоручениеИсходящее КАК ПлатежноеПоручениеИсходящее
		|ГДЕ
		|	ПлатежноеПоручениеИсходящее.Проведен
		|	И ПлатежноеПоручениеИсходящее.Дата МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ПлатежноеПоручениеИсходящее.БанковскийСчет = &БанковскийСчет
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер";
	Запрос.УстановитьПараметр("НачалоПериода", Объект.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(Объект.ДатаОкончания));
	Запрос.УстановитьПараметр("БанковскийСчет", Объект.БанковскийСчет);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда 
		ТекстСообщения = НСтр("ru = 'За указанный период нет данных для формирования файла.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат Неопределено;
	КонецЕсли;	
	
	ИмяФайла = ПолучитьИмяВременногоФайла("txt");
	Текст = Новый ЗаписьТекста(ИмяФайла, "windows-1251");
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл

		// 1. Reference Id - 20 - Текстовое поле, которое содержит только числа. Это поле используется для поиска платежа и сортировки.
		НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ВыборкаДетальныеЗаписи.Номер);
		Поле1 = Лев(НомерДокумента + Пробелы(20), 20);
		
		// 2. Date - 10 - Дата оплаты. Есть временное ограничение при отправке клиринга.
		// К примеру: если вы проводите платеж обычным клирингом до 10:30 рабочего дня, 
		// то ваш платеж уходит в этот же день, если же вы отправляете после 10:30 рабочего дня, 
		// то платеж отправляется следующим днем.
		// Если вы проводите платеж Гроссом до 15:30 рабочего дня, 
		// то ваш платеж уходит в этот же день, если же вы отправляете после 15:30 рабочего дня, 
		// то платеж отправляется следующим днем.
        Поле2 = Формат(ВыборкаДетальныеЗаписи.Дата, "ДФ=yyyy-MM-dd");
		
		// 3. ОКПО - 17 - Классификатор организации. 
		Поле3 = Лев(ВыборкаДетальныеЗаписи.ОрганизацияОКПО + Пробелы(17), 17);
		
		// 4. Tax Identification Number - 17 - ИНН. 
		Поле4 = Лев(ВыборкаДетальныеЗаписи.ОрганизацияИНН + Пробелы(17), 17);
		
		// 5. Registration number СФКР - 17 - СФКР. 
		Поле5 = Лев(ВыборкаДетальныеЗаписи.ОрганизацияРегНомерСоцФонда + Пробелы(17), 17);
		
		// 6. From bank code - 20 - Код банка отправителя. 
		Поле6 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетБанкКод + Пробелы(20), 20);
		
		// 7. From name - 100 - Имя отправителя. 
		Поле7 = Лев(ВыборкаДетальныеЗаписи.ОрганизацияНаименованиеПолное + Пробелы(100), 100);
		
		// 8. Debiting account number - 100 - Номер счета отправителя. 
		Поле8 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетНомерСчета + Пробелы(100), 100);
		
		// 9. From bank name - 200 - Наименование банка отправителя. 
		Поле9 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетБанкНаименование + Пробелы(200), 200);
		
		// 10. Receiver name - 150 - Имя получателя. 
		Поле10 = Лев(ВыборкаДетальныеЗаписи.КонтрагентНаименованиеПолное + Пробелы(150), 150);
		
		// 11. Crediting account no - 30 - Номер счета получателя. 
		Поле11 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетПолучателяНомерСчета + Пробелы(30), 30);
		
		// 12. Beneficiary account no - 20 - Счет бенефициара. 
		// Это поле не используется, можете оставить пустым. 
		Поле12 = Пробелы(20);
		
		// 13. To bank code - 20 - Код банка получателя. 
		Поле13 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетПолучателяБанкКод + Пробелы(20), 20);
		
		// 14. Receiver bank name - 200 - Наименование банка получателя. 
		Поле14 = Лев(ВыборкаДетальныеЗаписи.БанковскийСчетПолучателяБанкНаименование + Пробелы(200), 200);
		
		// 15. Amount (in words) - 200 - Наименование банка получателя.
		СуммаПрописью = БухгалтерскийУчетСервер.СформироватьСуммуПрописью(ВыборкаДетальныеЗаписи.СуммаДокумента, ВыборкаДетальныеЗаписи.ВалютаДокумента);
		Поле15 = Лев(СуммаПрописью + Пробелы(200), 200);
		
		// 16.Amount - 20 - Сумма. 
		СуммаДокумента = Формат(ВыборкаДетальныеЗаписи.СуммаДокумента, "ЧЦ=20; ЧДЦ=2; ЧРД=.; ЧРГ=,; ЧГ=3,0");
		Поле16 = Лев(СуммаДокумента + Пробелы(20), 20);
		
		// 17. Code of payment - 20 - Код платежа. 
		Поле17 = Лев(ВыборкаДетальныеЗаписи.КодПлатежаКод + Пробелы(20), 20);
		
		// 18. Currency Code - 10 - Код валюты.
		// Только в латинских буквах.
		Поле18 = Лев(ВыборкаДетальныеЗаписи.ВалютаДокументаНаименование + Пробелы(10), 10);
		
		// 19. Payment explanation - 700 - Назначение платежа. 
		// Текст может быть на латинице и на кириллице. 
		// Для того чтобы отправить платеж Гроссом, нужно добавить в конце текста #GROSS#.
		НазначениеПлатежа = ВыборкаДетальныеЗаписи.НазначениеПлатежа;
		Если ОтправкаГроссом Тогда 
			НазначениеПлатежа = НазначениеПлатежа + "#GROSS#";
		КонецЕсли;	
		Поле19 = Лев(НазначениеПлатежа + Пробелы(700), 700);
		
		// 20. AllocRef - 10 - Это поле не используется, можете оставить пустым. 
		// Но вы можете заполнять это поле если вы в будущем хотите делать поиск. 
		Поле20 = Пробелы(10);
		
		// 21. Customer reference id - 10 - Это поле не используется, можете оставить пустым. 
		Поле21 = Пробелы(10);
		
		Запись = Поле1 + Символы.Таб
			+ Поле2 + Символы.Таб
			+ Поле3 + Символы.Таб
			+ Поле4 + Символы.Таб
			+ Поле5 + Символы.Таб
			+ Поле6 + Символы.Таб
			+ Поле7 + Символы.Таб
			+ Поле8 + Символы.Таб
			+ Поле9 + Символы.Таб
			+ Поле10 + Символы.Таб
			+ Поле11 + Символы.Таб
			+ Поле12 + Символы.Таб
			+ Поле13 + Символы.Таб
			+ Поле14 + Символы.Таб
			+ Поле15 + Символы.Таб
			+ Поле16 + Символы.Таб
			+ Поле17 + Символы.Таб
			+ Поле18 + Символы.Таб
			+ Поле19 + Символы.Таб
			+ Поле20 + Символы.Таб
			+ Поле21;
			
		Текст.ЗаписатьСтроку(Запись);
	КонецЦикла;

	Текст.Закрыть();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
	
	УдалитьФайлы(ИмяФайла);
	Возврат АдресВоВременномХранилище;
КонецФункции

// Функция - Пробелы
//
// Параметры:
//  Количество	 - Число - Количество пробелов.
// 
// Возвращаемое значение:
//  Результат - Строка
//
&НаСервере
Функция Пробелы(Количество)

	Результат = "";
	
	Для Шаг = 1 По Количество Цикл
		Результат = Результат + " ";
	КонецЦикла;	
	
	Возврат Результат

КонецФункции // Пробелы()

&НаКлиенте
Процедура ПрочитатьНаКлиенте()

	ТаблицаДокументыКСозданию.Очистить();
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайлаЗагрузки);
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтаФорма.УникальныйИдентификатор);
	ПрочитатьНаСервере(АдресВоВременномХранилище);

КонецПроцедуры // ПрочитатьНаКлиенте()

&НаСервере
Процедура ПрочитатьНаСервере(АдресВоВременномХранилище)
	
	ИмяФайла = ПолучитьИмяВременногоФайла("xml");
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ДвоичныеДанные.Записать(ИмяФайла);

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ИмяФайла);
	
	КлассификаторТаблица = ОбщегоНазначения.ПрочитатьXMLВТаблицу(ЧтениеXML).Данные;
	             
	Для Каждого СтрокаТаблицыЗначений Из КлассификаторТаблица Цикл
		НоваяСтрокаТаблицыЗначений = ТаблицаДокументыКСозданию.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТаблицыЗначений, СтрокаТаблицыЗначений);
		
		// Валюта.
		НоваяСтрокаТаблицыЗначений.ВалютаБанковскогоСчета = Справочники.Валюты.НайтиПоНаименованию(НоваяСтрокаТаблицыЗначений.КодВалютыБанковскогоСчетаОрганизации, Истина);
		НоваяСтрокаТаблицыЗначений.ВалютаКонтрагента = Справочники.Валюты.НайтиПоНаименованию(НоваяСтрокаТаблицыЗначений.КодВалютыБанковскогоСчетаКонтрагента, Истина);
		
		// Контрагент.
		НоваяСтрокаТаблицыЗначений.Контрагент = Справочники.Контрагенты.НайтиПоНаименованию(НоваяСтрокаТаблицыЗначений.НаименованиеКонтрагента, Истина);
		
		// Банковский счет.
		НоваяСтрокаТаблицыЗначений.БанковскийСчет = Справочники.БанковскиеСчета.НайтиПоНомеруСчета(НоваяСтрокаТаблицыЗначений.НомерБанковскогоСчетаОрганизации, 
			Объект.Организация, НоваяСтрокаТаблицыЗначений.ВалютаБанковскогоСчета);
		НоваяСтрокаТаблицыЗначений.БанковскийСчетПлательщика = Справочники.БанковскиеСчета.НайтиПоНомеруСчета(НоваяСтрокаТаблицыЗначений.НомерБанковскогоСчетаКонтрагента, 
			НоваяСтрокаТаблицыЗначений.Контрагент, НоваяСтрокаТаблицыЗначений.ВалютаКонтрагента);
	КонецЦикла;
	
КонецПроцедуры // ПрочитатьНаСервере()

#КонецОбласти
