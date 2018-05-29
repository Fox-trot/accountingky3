﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиТекущемуПользователю() <> Истина Тогда
		Отказ = Истина;
		СтандартнаяОбработка= Ложь;
		Возврат;
	КонецЕсли;

	// Если передали явный список лент новостей, то использовать его.
	// В противном случае рассчитать только видимые пользователю ленты новостей.
	Если Параметры.ПропуститьЗаполнениеНовостями = Истина Тогда

		лкТаблицаКонтекстныхНовостей = ЭтотОбъект.ТаблицаНовостей.Выгрузить();

	Иначе

		Если Параметры.СписокЛентНовостей.Количество() > 0 Тогда
			лкСписокЛентНовостей = Параметры.СписокЛентНовостей;
		Иначе
			МассивДоступныхЛентНовостей = ХранилищаНастроек.НастройкиНовостей.Загрузить(
				"ДоступныеЛентыНовостей", // КлючОбъекта
				""); // КлючНастроек, пока не обрабатывается
			лкСписокЛентНовостей = Новый СписокЗначений;
			лкСписокЛентНовостей.ЗагрузитьЗначения(МассивДоступныхЛентНовостей);
		КонецЕсли;

		НастройкиПолученияНовостей = Неопределено;
		лкТаблицаКонтекстныхНовостей = ОбработкаНовостей.ПолучитьКонтекстныеНовости(
			лкСписокЛентНовостей,
			?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
			?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
			?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
			"Для формы контекстных новостей", // Вариант запроса для контекстных новостей.
			НастройкиПолученияНовостей);

	КонецЕсли;

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьТаблицуКонтекстныхНовостей(
		?(ПустаяСтрока(Параметры.ИмяМетаданных), Неопределено, Параметры.ИмяМетаданных),
		?(ПустаяСтрока(Параметры.ИмяФормы), Неопределено, Параметры.ИмяФормы),
		?(ПустаяСтрока(Параметры.ИмяСобытия), Неопределено, Параметры.ИмяСобытия),
		лкТаблицаКонтекстныхНовостей);

	ЭтотОбъект.ТаблицаНовостей.Загрузить(лкТаблицаКонтекстныхНовостей);

	Если Параметры.СкрыватьКолонкуПодзаголовок = Истина Тогда
		Элементы.ТаблицаНовостейПодзаголовок.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуДатаПубликации = Истина Тогда
		Элементы.ТаблицаНовостейДатаПубликации.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.СкрыватьКолонкуЛентаНовостей = Истина Тогда
		Элементы.ТаблицаНовостейЛентаНовостей.Видимость = Ложь;
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	Если НЕ ПустаяСтрока(Параметры.ЗаголовокФормы) Тогда
		ЭтотОбъект.Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;

	Если ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Независимый") Тогда
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.Независимый;
	ИначеЕсли ВРег(СокрЛП(Параметры.РежимОткрытияОкна)) = ВРег("Блокировать весь интерфейс") Тогда
		ЭтотОбъект.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс;
	Иначе // Блокировать окно владельца
		//
	КонецЕсли;

	УстановитьУсловноеОформление();

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуКонтекстныхНовостейПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если ЭтотОбъект.ТаблицаНовостей.Количество() <= 0 Тогда
		Отказ = Истина;
		// Вывести сообщение, что нет контекстных новостей
		ТекстСообщения     = НСтр("ru='Для этой формы нет контекстных новостей.'");
		ПояснениеСообщения = НСтр("ru='Нажмите здесь для просмотра всех новостей.'");
		ОбработкаНовостейКлиентПереопределяемый.ПереопределитьНадписиСообщенияПриОтсутствииКонтекстныхНовостей(
			ЭтотОбъект,
			ТекстСообщения,
			ПояснениеСообщения,
			Отказ);
		Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
			ПоказатьОповещениеПользователя(
				ТекстСообщения, // Текст,
				ОбработкаНовостейКлиентСервер.ПолучитьНавигационнуюСсылкуСпискаНовостей(), // НавигационнаяСсылка
				ПояснениеСообщения, // Пояснение,
				БиблиотекаКартинок.Новости); // Картинка
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Новость прочтена" Тогда
		// Если новостей > 20, то это может привести к неявному вызову сервера
		НайденныеСтроки = ЭтотОбъект.ТаблицаНовостей.НайтиСтроки(Новый Структура("Новость", Источник)); // Источник = Новость
		Для каждого ТекущаяСтрока Из НайденныеСтроки Цикл
			ТекущаяСтрока.Прочтена = Параметр; // Параметр = Прочтена
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ТаблицаНовостей

&НаКлиенте
Процедура ТаблицаНовостейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	Если ВыбраннаяСтрока <> Неопределено Тогда
		НайденнаяНовость = ЭтотОбъект.ТаблицаНовостей.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если НайденнаяНовость <> Неопределено Тогда
		ОбработкаНовостейКлиент.ПоказатьНовость(
			НайденнаяНовость.Новость,
			Новый Структура("РежимОткрытияОкна",
				"БлокироватьОкноВладельца"), // Параметры
			ЭтотОбъект,
			Истина); // Без уникальности
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОткрытьНовость(Команда)

	Если Элементы.ТаблицаНовостей.ТекущиеДанные <> Неопределено Тогда
		ОбработкаНовостейКлиент.ПоказатьНовость(
			Элементы.ТаблицаНовостей.ТекущиеДанные.Новость,
			Новый Структура("РежимОткрытияОкна",
				"БлокироватьОкноВладельца"), // Параметры
			ЭтотОбъект,
			Истина); // Без уникальности
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Непрочтенные новости (ДатаПубликации, Наименование и Подзаголовок) - жирным.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейНаименование.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейПодзаголовок.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейДатаПубликации.Имя);
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаНовостейЛентаНовостей.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаНовостей.Прочтена");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ШрифтНовостей, , , Истина)); // Жирный

		// Использование
		Элемент.Использование = Истина;

	// Другие произвольные настройки условного оформления, настраиваемые для конкретной конфигурации.
	ОбработкаНовостейПереопределяемый.ДополнительноУстановитьУсловноеОформлениеФормыКонтекстныхНовостей(ЭтотОбъект, УсловноеОформление);

КонецПроцедуры

#КонецОбласти
