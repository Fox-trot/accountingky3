﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
// В процедуре осуществляется
// - инициализация реквизитов формы,
// - установка параметров функциональных опций формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЭтаФорма.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Если ОбработкаНовостейПовтИсп.РазрешенаРаботаСНовостямиЧерезИнтернет() = Истина Тогда
		Элементы.ДекорацияРежимРаботыСНовостямиЧерезИнтернет_ОбновлениеКлассификаторов.Видимость = Ложь;
	КонецЕсли;

	Если Параметры.Свойство("ОткрытаИзОбработки_УправлениеНовостями") Тогда
		ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;
	Иначе
		ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Ложь;
	КонецЕсли;

	ОбновитьИнформационныеСтроки();

	УстановитьУсловноеОформление();

КонецПроцедуры

// Процедура - обработчик события ОбработкаОповещения.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Обновились данные классификаторов новостей с сервера 1С" Тогда // Идентификатор.
		Элементы.Список.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылка, СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылка) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ОткрытьФорму(
			"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
			Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
			ЭтаФорма,
			"");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОбновитьССервера(Команда)

	ОткрытьФорму(
		"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
		Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
		ЭтаФорма,
		"");

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

	ТребуетсяОбновление = Ложь;

	Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
	Запись.Список = "Список категорий новостей"; // Идентификатор.
	Запись.Прочитать(); // Только чтение, без последующей записи.

	Если Запись.Выбран() Тогда
		Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Данные актуальны и соответствуют данным с сервера от %1.'"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Ложь;
		Иначе // Устарели
			Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
				ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера,
					|а на сервере уже версия от %2.'");
			Иначе
				ТекстНадписи = НСтр("ru='Последний раз данные обновлялись с сервера %1,
					|а на сервере уже версия от %2.'");
			КонецЕсли;
			ТекстНадписи = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстНадписи,
				Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"),
				Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
			ТребуетсяОбновление = Истина;
		КонецЕсли;
	Иначе
		ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера.'");
		ТребуетсяОбновление = Истина;
	КонецЕсли;

	Если ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
		Если (ЭтаФорма.РольДоступнаАдминистратор = Истина) Тогда
			// Если эта форма открыта из формы обработки "Управление новостями", то
			//  не давать снова открывать форму обработки.
			Если ЭтаФорма.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
				Если ТребуетсяОбновление = Истина Тогда
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
				Иначе
					Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
				КонецЕсли;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = Новый ФорматированнаяСтрока(
					ТекстНадписи + " ",
					Новый ФорматированнаяСтрока(
						НСтр("ru='Проверить обновления.'"),
						,
						ЦветаСтиля.ЦветГиперссылки,
						,
						"Update"));
			КонецЕсли;
		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок   = ТекстНадписи;
			Если ТребуетсяОбновление = Истина Тогда
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
			Иначе
				Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
// Параметры:
//  Нет.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Автоматически заполняемыеэлементы - серым цветом.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЗаполняетсяАвтоматически");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти
