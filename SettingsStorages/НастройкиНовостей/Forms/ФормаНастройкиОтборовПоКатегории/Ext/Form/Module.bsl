﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если (ОбщегоНазначения.РазделениеВключено())
			// Зашли в конфигурацию под пользователем без разделения (АдминистраторСистемы или фоновое задание (пустой пользователь)).
			И (ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей()) Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;

	Если Параметры.ТекущийПользователь.Пустая()
			ИЛИ (ПравоДоступа("СохранениеДанныхПользователя", Метаданные) = Ложь) Тогда
		ЭтотОбъект.ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		ЭтотОбъект.ТекущийПользователь = Параметры.ТекущийПользователь;
	КонецЕсли;

	ЭтотОбъект.ЗакрыватьПриВыборе = Истина; // После вызова ОповеститьОВыборе форма автоматически закроется

	ЭтотОбъект.ЛентаНовостей     = Параметры.ЛентаНовостей;
	ЭтотОбъект.КатегорияНовостей = Параметры.КатегорияНовостей;

	ЗаполнитьФормуДаннымиСервер(Параметры.СписокЗначенийОтборов, Параметры.СписокЗначенийГлобальныхОтборов);

	Если ЭтотОбъект.ЛентаНовостей.Пустая() Тогда
		ТекстСообщения = НСтр("ru='Не заполнено значение Ленты новостей.
			|Настройка отбора невозможна.'");
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	Если ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		ТекстСообщения = НСтр("ru='Не заполнено значение Категории новостей.
			|Настройка отбора невозможна.'");
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ТекстСообщения;
		Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;

	Если ЭтотОбъект.ТекущийПользователь <> ПользователиКлиентСервер.ТекущийПользователь() Тогда
		ЭтотОбъект.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Настройка отборов для ленты новостей по категории (%1)'"),
			ЭтотОбъект.ТекущийПользователь);
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_ДоступныеЗначенияКатегории_Справочник

&НаКлиенте
Процедура ДоступныеЗначенияКатегории_СправочникПометкаПриИзменении(Элемент)

	Если Элементы.ДоступныеЗначенияКатегории_Справочник.ТекущаяСтрока <> Неопределено Тогда
		НайденнаяСтрока = ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник.НайтиПоИдентификатору(Элементы.ДоступныеЗначенияКатегории_Справочник.ТекущаяСтрока);
		Если НайденнаяСтрока <> Неопределено Тогда
			Если НайденнаяСтрока.Пометка = Истина Тогда
				РекурсивноУстановитьПометку(НайденнаяСтрока.ПолучитьЭлементы(), НайденнаяСтрока.Пометка);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)

	Если ПроверитьЗаполнение() Тогда
		// Данные для передачи владельцу - только список значений.
		Результат = ПодготовитьСтруктуруДляВозвратаПоОК();
		ОповеститьОВыборе(Результат);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)

	ЭтотОбъект.Закрыть(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура КомандаУстановитьФлажки_Справочник(Команда)

	РекурсивноУстановитьПометку(ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы(), Истина);

КонецПроцедуры

&НаКлиенте
Процедура КомандаСнятьФлажки_Справочник(Команда)

	РекурсивноУстановитьПометку(ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы(), Ложь);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьСтруктуруДляВозвратаПоОК()

	ТипСтрока         = Тип("Строка");
	ТипЧисло          = Тип("Число");
	ТипДата           = Тип("Дата");
	ТипБулево         = Тип("Булево");
	ТипСписокЗначений = Тип("СписокЗначений");

	// Удалить дублирующиеся значения.
	// Выгрузить значения в список.
	Список = Неопределено;
	Если ЭтотОбъект.ДоступныеЗначенияКатегории_НастроеноАдминистратором.Количество() > 0 Тогда
		Список = Новый СписокЗначений;
		Для каждого ТекущийОтбор Из ЭтотОбъект.ДоступныеЗначенияКатегории_НастроеноАдминистратором Цикл
			Если ТекущийОтбор.Пометка = Истина Тогда
				Список.Добавить(ТекущийОтбор.Значение);
			КонецЕсли;
		КонецЦикла;
	Иначе
		Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипСтрока Тогда
			Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Скопировать();
		ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипЧисло Тогда
			Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Скопировать();
		ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипДата Тогда
			Список = ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Скопировать();
		ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипБулево Тогда
			// Одно значение.
			Список = Новый СписокЗначений;
			Список.Добавить(ЭтотОбъект.ДоступныеЗначенияКатегории_Булево);
		ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.ЗначенияКатегорийНовостей") Тогда
			Список = ПолучитьСписокЗначенийИзДереваСПометками(ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник);
		КонецЕсли;
	КонецЕсли;

	// Свернуть список значений - повторов быть не должно.
	Если ТипЗнч(Список) = ТипСписокЗначений Тогда
		БылиУдаления = Истина;
		Пока БылиУдаления = Истина Цикл
			БылиУдаления = Ложь;
			Для С1=0 По Список.Количество()-1 Цикл
				Для С2=С1+1 По Список.Количество()-1 Цикл
					Если С1<>С2 Тогда
						Если (С1<=Список.Количество()-1) И (С2<=Список.Количество()-1) Тогда
							Если Список[С1].Значение = Список[С2].Значение Тогда
								Список.Удалить(С2);
								БылиУдаления = Истина;
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;

	Возврат Список;

КонецФункции

// Процедура заполняет дерево значений из справочника "ЗначенияКатегорийНовостей" для Категории.
//
// Параметры:
//  Строки                - Заполняемые строки дерева значений;
//  Родитель              - СправочникСсылка.ЗначенияКатегорийНовостей - родитель;
//  СписокЗначенийОтборов - Список значений - Список значений, по которым уже включен отбор, если включена пометка, то это глобальный отбор (настроенный администратором).
//
&НаСервереБезКонтекста
Процедура ЗаполнитьДеревоИзСправочника(Строки, Знач Владелец, Знач Родитель, Знач СписокЗначенийОтборов)

	Выборка = Справочники.ЗначенияКатегорийНовостей.Выбрать(Родитель, Владелец, , "Наименование");
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Строки.Добавить();
		НоваяСтрока.ЗначениеКатегорииНовостей = Выборка.Ссылка;
		НайденнаяСтрока = СписокЗначенийОтборов.НайтиПоЗначению(Выборка.Ссылка);
		Если НайденнаяСтрока <> Неопределено Тогда
			НоваяСтрока.Пометка = Истина;
			НоваяСтрока.ЭтоГлобальныйОтбор = НайденнаяСтрока.Пометка;
		КонецЕсли;
		ЗаполнитьДеревоИзСправочника(НоваяСтрока.ПолучитьЭлементы(), Владелец, Выборка.Ссылка, СписокЗначенийОтборов);
	КонецЦикла;

КонецПроцедуры

&НаСервереБезКонтекста
// Функция возвращает список значений из дерева с пометками.
// 
// Параметры:
//  Дерево    - Дерево значений с пометками, обязательные поля: ЗначениеКатегорииНовостей, Пометка;
//  Список    - Список значений - в него также будет помещено результирующее значение.
//
// Возвращаемое значение:
//  Список значений.
//
Функция ПолучитьСписокЗначенийИзДереваСПометками(Знач Дерево, Знач Список = Неопределено)

	ТипСписокЗначений = Тип("СписокЗначений");

	Если ТипЗнч(Список) = ТипСписокЗначений Тогда
		Результат = Список.Скопировать();
	Иначе
		Результат = Новый СписокЗначений;
	КонецЕсли;

	ЭлементыДерева = Дерево.ПолучитьЭлементы();
	Для каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Пометка Тогда
			Если Результат.НайтиПоЗначению(ЭлементДерева.ЗначениеКатегорииНовостей) = Неопределено Тогда
				Результат.Добавить(ЭлементДерева.ЗначениеКатегорииНовостей, , ЭлементДерева.ЭтоГлобальныйОтбор);
			КонецЕсли;
		КонецЕсли;
		ПолучитьСписокЗначенийИзДереваСПометками(ЭлементДерева, Результат);
	КонецЦикла;

	Список = Результат.Скопировать();

	Возврат Результат;

КонецФункции

// Процедура может очистить значение категории новостей, если в данной ленте новостей нет отбора по такой категории.
// Заполняет данными уже установленных ранее отборов.
// Также отображает правильную страницу на форме.
//
// Параметры:
//  СписокЗначенийОтборов - СписокЗначений - список установленных отборов.
//
&НаСервере
Процедура ЗаполнитьФормуДаннымиСервер(Знач СписокЗначенийОтборов, Знач СписокЗначенийГлобальныхОтборов)

	ТипСтрока = Тип("Строка");
	ТипЧисло  = Тип("Число");
	ТипДата   = Тип("Дата");
	ТипБулево = Тип("Булево");

	// Загрузить глобальные отборы.
	ЭтотОбъект.ДоступныеЗначенияКатегории_НастроеноАдминистратором.ЗагрузитьЗначения(СписокЗначенийГлобальныхОтборов.ВыгрузитьЗначения());

	// Есть ли такая категория в этой ленте новостей?
	НайденнаяСтрока = ЭтотОбъект.ЛентаНовостей.ДоступныеКатегорииНовостей.Найти(ЭтотОбъект.КатегорияНовостей, "КатегорияНовостей");
	Если НайденнаяСтрока = Неопределено Тогда
		ЭтотОбъект.КатегорияНовостей = ПланыВидовХарактеристик.КатегорииНовостей.ПустаяСсылка();
	КонецЕсли;
	// Заполнить параметры выбора для категории новостей для Ссылок - должны попадать только доступные категории.
	ЭтотОбъект.ЛентаНовостей_ДоступныеКатегории.ЗагрузитьЗначения(ЭтотОбъект.ЛентаНовостей.ДоступныеКатегорииНовостей.ВыгрузитьКолонку("КатегорияНовостей"));

	Если НЕ ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы().Количество() >= 1 Тогда
			ЭтотОбъект.ТипЗначенияКатегории = ЭтотОбъект.КатегорияНовостей.ТипЗначения;
		Иначе
			ЭтотОбъект.ТипЗначенияКатегории = Новый ОписаниеТипов;
		КонецЕсли;
	Иначе
		ЭтотОбъект.ТипЗначенияКатегории = Новый ОписаниеТипов;
	КонецЕсли;

	Если ЭтотОбъект.ЛентаНовостей.Пустая() ИЛИ ЭтотОбъект.КатегорияНовостей.Пустая() Тогда
		Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница=Элементы.СтраницаДоступныеЗначения_Пустая;
	Иначе
		// Если настроены глобальные отборы, то позволить отбирать только из них.
		Если ЭтотОбъект.ДоступныеЗначенияКатегории_НастроеноАдминистратором.Количество() > 0 Тогда
			// Загрузить данные.
			Для каждого ТекущийОтбор Из ЭтотОбъект.ДоступныеЗначенияКатегории_НастроеноАдминистратором Цикл
				НайденнаяСтрока = СписокЗначенийОтборов.НайтиПоЗначению(ТекущийОтбор.Значение);
				Если НайденнаяСтрока = Неопределено Тогда
					ТекущийОтбор.Пометка = Ложь;
				Иначе
					ТекущийОтбор.Пометка = Истина;
				КонецЕсли;
			КонецЦикла;
			// Отобразить правильную закладку.
			Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_СписокЗначений;
		Иначе
			Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы().Количество()>=1 Тогда
				// Если тип значения - строка, тогда просто загрузить значения отборов;
				// Если тип значения - число, тогда просто загрузить значения отборов;
				// Если тип значения - дата, тогда просто загрузить значения отборов;
				// Если тип значения - булево, тогда просто загрузить значения отборов;
				// Если тип значения - справочник, тогда сгенерировать дерево значений;
				// Если в ТекущийОтбор.Пометка хранится ИСТИНА, то это ЭтоГлобальныйОтбор.

				Если ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипСтрока Тогда
					// Загрузить данные.
					ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Очистить();
					Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
						ЭтотОбъект.ДоступныеЗначенияКатегории_Строка.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
					КонецЦикла;
					// Отобразить правильную закладку.
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Строка;

				ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипЧисло Тогда
					// Загрузить данные.
					ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Очистить();
					Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
						ЭтотОбъект.ДоступныеЗначенияКатегории_Число.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
					КонецЦикла;
					// Отобразить правильную закладку
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Число;

				ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипДата Тогда
					// Загрузить данные
					ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Очистить();
					Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
						ЭтотОбъект.ДоступныеЗначенияКатегории_Дата.Добавить(ТекущийОтбор.Значение, , ТекущийОтбор.Пометка);
					КонецЦикла;
					// Отобразить правильную закладку.
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Дата;

				ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = ТипБулево Тогда
					// Загрузить данные.
					// Для значений типа "Булево" не имеет смысла в регистре сведений хранить несколько значений,
					//  поэтому прочитано будет только первое значение.
					ЭтотОбъект.ДоступныеЗначенияКатегории_Булево = Истина;
					Для каждого ТекущийОтбор Из СписокЗначенийОтборов Цикл
						ЭтотОбъект.ДоступныеЗначенияКатегории_Булево = ТекущийОтбор.Значение;
						Если ТекущийОтбор.Пометка Тогда
							Элементы.ДоступныеЗначенияКатегории_Булево.Доступность = Ложь;
						Иначе
							Элементы.ДоступныеЗначенияКатегории_Булево.Доступность = Истина;
						КонецЕсли;
						Прервать;
					КонецЦикла;
					// Отобразить правильную закладку.
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Булево;

				ИначеЕсли ЭтотОбъект.КатегорияНовостей.ТипЗначения.Типы()[0] = Тип("СправочникСсылка.ЗначенияКатегорийНовостей") Тогда
					// Загрузить данные - это пометки.
					// Также заполнить настроенные ранее отборы.
					ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы().Очистить();
					ЗаполнитьДеревоИзСправочника(
						ЭтотОбъект.ДоступныеЗначенияКатегории_Справочник.ПолучитьЭлементы(),
						ЭтотОбъект.КатегорияНовостей,
						Справочники.ЗначенияКатегорийНовостей.ПустаяСсылка(),
						СписокЗначенийОтборов);
					// Отобразить правильную закладку.
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Справочник;

				Иначе
					Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Пустая;
				КонецЕсли;
			Иначе
				Элементы.ГруппаСтраницыДоступныеЗначения.ТекущаяСтраница = Элементы.СтраницаДоступныеЗначения_Пустая;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Процедура заполняет колонку Пометку произвольного дерева значением Пометка.
//
// Параметры:
//  ЭлементыДерева - Элементы дерева;
//  Пометка        - Булево - значение пометки.
//
Процедура РекурсивноУстановитьПометку(ЭлементыДерева, Пометка=Истина)

	Для каждого ТекущийЭлементДерева Из ЭлементыДерева Цикл
		ТекущийЭлементДерева.Пометка = Пометка;
		РекурсивноУстановитьПометку(ТекущийЭлементДерева.ПолучитьЭлементы(), Пометка);
	КонецЦикла;

КонецПроцедуры

// Процедура устанавливает условное оформление в форме.
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Только просмотр для ДоступныеЗначенияКатегории_Справочник.ЭтоГлобальныйОтбор = Истина.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДоступныеЗначенияКатегории_СправочникПометка.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДоступныеЗначенияКатегории_Справочник.ЭтоГлобальныйОтбор");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

		// Использование
		Элемент.Использование = Истина;

	// 2. Цвет текста, Только просмотр для ДоступныеЗначенияКатегории_Справочник.ЭтоГлобальныйОтбор = Истина.
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДоступныеЗначенияКатегории_СправочникСсылка.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДоступныеЗначенияКатегории_Справочник.ЭтоГлобальныйОтбор");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

	// 3. Цвет текста, Только просмотр для ДоступныеЗначенияКатегории_Строка.Пометка Равно "Истина".
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДоступныеЗначенияКатегории_СтрокаЗначение.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДоступныеЗначенияКатегории_Строка.Пометка");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

	// 4. Цвет текста, Только просмотр для ДоступныеЗначенияКатегории_Число.Пометка Равно "Истина".
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДоступныеЗначенияКатегории_ЧислоЗначение.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ДоступныеЗначенияКатегории_Число.Пометка");
		ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти
