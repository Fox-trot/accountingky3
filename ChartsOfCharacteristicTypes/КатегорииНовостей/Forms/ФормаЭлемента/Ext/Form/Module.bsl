﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, то нельзя редактировать ВНЕ зависимости от того,
		//  под каким пользователем зашли - разделенным или неразделенным.
		ЭтотОбъект.ТолькоПросмотр = Истина;
	Иначе
		ЭтотОбъект.ТолькоПросмотр = Ложь;
	КонецЕсли;

	ЭтотОбъект.РольДоступнаАдминистратор = ОбработкаНовостейПовтИсп.ЭтоАдминистратор();

	Если Параметры.Ключ.Пустая() Тогда
		Элементы.ГруппаЗначенияКатегорий.Видимость = Ложь;
		// Вручную создается новая категория, надо сбросить признак "ЗагруженоССервера".
		Объект.ЗагруженоССервера = Ложь;
	Иначе
		Элементы.ГруппаЗначенияКатегорий.Видимость = Истина;
	КонецЕсли;

	Если ЭтотОбъект.ЗначенияКатегорийНовостейСправочник.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество() = 1 Тогда
		// Может вызвать ошибку в неразделенном режиме в модели сервиса.
		НовыйОтбор = ЭтотОбъект.ЗначенияКатегорийНовостейСправочник.КомпоновщикНастроек.Настройки.Отбор.Элементы[0];
		НовыйОтбор.ПравоеЗначение = Объект.Ссылка;
		НовыйОтбор.Использование  = Истина;
	Иначе
		ЭтотОбъект.ЗначенияКатегорийНовостейСправочник.Отбор.Элементы.Очистить();
		НовыйОтбор = ЭтотОбъект.ЗначенияКатегорийНовостейСправочник.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("Владелец");
		НовыйОтбор.ПравоеЗначение = Объект.Ссылка;
		НовыйОтбор.Использование  = Истина;
	КонецЕсли;

	Если Параметры.Свойство("ОткрытаИзОбработки_УправлениеНовостями") Тогда
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Параметры.ОткрытаИзОбработки_УправлениеНовостями;
	Иначе
		ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Ложь;
	КонецЕсли;

	Если (Объект.ЗагруженоССервера = Истина) Тогда
		Элементы.ЗагруженоССервера.Видимость = Истина; // Вывести надпись, что редактирование невозможно.
		ЭтотОбъект.ТолькоПросмотр = Истина;
	Иначе
		ЭтотОбъект.ТолькоПросмотр = Ложь;
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

	ОбновитьИнформационныеСтроки();

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Элементы.ГруппаЗначенияКатегорий.Видимость = Истина;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// Сейчас в отборе - пустая ссылка. Установить явно новую ссылку для только что записанного объекта.
	ЭтотОбъект.ЗначенияКатегорийНовостейСправочник.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Объект.Ссылка;

	ОбновитьИнформационныеСтроки();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "Новости. Обновились данные классификаторов новостей с сервера 1С" Тогда // Идентификатор.
		Элементы.ЗначенияКатегорийНовостейСправочник.Обновить();
		ОбновитьИнформационныеСтроки();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)

	// Добавили новое значение подчиненного справочника.
	СтандартнаяОбработка = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипЗначенияВспомогательныйПриИзменении(Элемент)

	ТипЗначенияВспомогательныйПриИзмененииНаСервере();

КонецПроцедуры

&НаСервере
Процедура ТипЗначенияВспомогательныйПриИзмененииНаСервере()

	Если Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Булево Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Булево");
	ИначеЕсли Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Дата Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Дата");
	ИначеЕсли Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Строка Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Строка");
	ИначеЕсли Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.Число Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Число");
	ИначеЕсли Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ЗначенияКатегорийНовостей Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ЗначенияКатегорийНовостей");
	ИначеЕсли Объект.ТипЗначенияВспомогательный = Перечисления.ТипыЗначенийКатегорийНовостей.СправочникСсылка_ИнтервалыВерсийПродукта Тогда
		Объект.ТипЗначения = Новый ОписаниеТипов("Строка");
	КонецЕсли;

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполняетсяАвтоматическиПриИзменении(Элемент)

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбновляетсяССервераПриИзменении(Элемент)

	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияТребуетсяОбновлениеССервераОбработкаНавигационнойСсылки(
			Элемент,
			НавигационнаяСсылкаФорматированнойСтроки,
			СтандартнаяОбработка)

	Если ВРег(НавигационнаяСсылкаФорматированнойСтроки) = ВРег("Update") Тогда

		СтандартнаяОбработка = Ложь;

		ОткрытьФорму(
			"Обработка.УправлениеНовостями.Форма.ФормаНастроекНовостей",
			Новый Структура("ТекущаяСтраница", "СтраницаОбновленияСтандартныхСписков"),
			ЭтотОбъект,
			"");

	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;

	ТипСтруктура = Тип("Структура");

	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ЗаполняетсяАвтоматически",   Объект.ЗаполняетсяАвтоматически);
	СтруктураПараметров.Вставить("Ссылка",                     Объект.Ссылка);
	СтруктураПараметров.Вставить("ТипЗначения",                Объект.ТипЗначения);
	СтруктураПараметров.Вставить("ТипЗначенияВспомогательный", Объект.ТипЗначенияВспомогательный);
	СтруктураПараметров.Вставить("ОбновляетсяССервера",        Объект.ОбновляетсяССервера);

	СтруктураДействий = УправлениеФормойСервер(СтруктураПараметров);

	Если ТипЗнч(СтруктураДействий) = ТипСтруктура Тогда
		Для каждого КлючЗначение Из СтруктураДействий Цикл
			Если КлючЗначение.Ключ = "ФиксированноеЗначение" Тогда
				Подсказка = Элементы.ЗаполняетсяАвтоматически.Подсказка;
				Подсказка = 
					СтрПолучитьСтроку(Подсказка, 1) + Символы.ПС
					+ СтрПолучитьСтроку(Подсказка, 2) + Символы.ПС
					+ СокрЛП(КлючЗначение.Значение);
				Элементы.ЗаполняетсяАвтоматически.Подсказка = Подсказка;
			ИначеЕсли КлючЗначение.Ключ = "СтраницаЗначенийКатегорий" Тогда
				// Если это "Справочник.ЗначенияКатегорийНовостей", то разрешить вводить элементы внизу.
				Элементы.ГруппаЗначенияКатегорий.ТекущаяСтраница = Элементы[КлючЗначение.Значение];
			ИначеЕсли КлючЗначение.Ключ = "ОбновляетсяССервера" Тогда
				// Запретить изменять список значений.
				Если Объект.ОбновляетсяССервера = Истина Тогда
					Элементы.ЗначенияКатегорийНовостейСправочник.ТолькоПросмотр = Истина;
					Элементы.ЗначенияКатегорийНовостейСправочник.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
					Элементы.ЗначенияКатегорийНовостейСправочник.Заголовок = НСтр("ru='Список доступных значений (обновляется с сервера, редактирование запрещено)'");
				Иначе
					Элементы.ЗначенияКатегорийНовостейСправочник.ТолькоПросмотр = Ложь;
					Элементы.ЗначенияКатегорийНовостейСправочник.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Верх;
					Элементы.ЗначенияКатегорийНовостейСправочник.Заголовок = НСтр("ru='Список доступных значений'");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция УправлениеФормойСервер(Знач СтруктураПараметров)

	СтруктураДействий = Новый Структура;

	ТипОписаниеТипов             = Тип("ОписаниеТипов");
	ТипТип                       = Тип("Тип");
	ТипЗначениеКатегорииНовостей = Тип("СправочникСсылка.ЗначенияКатегорийНовостей");

	// Подсказка для поля ЗаполняетсяАвтоматически.
	Если СтруктураПараметров.ЗаполняетсяАвтоматически = Истина Тогда
		Значение = ОбработкаНовостейПовтИсп.ПолучитьЗначениеПредопределеннойКатегории(СтруктураПараметров.Ссылка);
		Если ПустаяСтрока(Значение) Тогда
			СтруктураДействий.Вставить("ФиксированноеЗначение", НСтр("ru='Невозможно определить значение для этой категории'"));
			// Также сделать недоступным страницу СтраницаСправочник.
			СтруктураДействий.Вставить("СтраницаЗначенийКатегорий", "СтраницаПустая");
		Иначе
			СтруктураДействий.Вставить(
				"ФиксированноеЗначение",
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru='Для этой конфигурации значение этой категории на текущий момент равно %1'"),
					Значение));
		КонецЕсли;
	Иначе
		СтруктураДействий.Вставить("ФиксированноеЗначение", "");
	КонецЕсли;

	// Текущая страница группы ГруппаЗначенияКатегорий - зависит от поля ТипЗначений и от того,
	//  не было ли ранее оно заполнено (в случае, если значение - пустое).
	Если СтруктураДействий.Свойство("СтраницаЗначенийКатегорий") = Ложь Тогда
		Если (ТипЗнч(СтруктураПараметров.ТипЗначения) = ТипОписаниеТипов) Тогда
			Если СтруктураПараметров.ТипЗначения.СодержитТип(ТипЗначениеКатегорииНовостей) Тогда
				СтруктураДействий.Вставить("СтраницаЗначенийКатегорий", "СтраницаСправочник");
			Иначе
				СтруктураДействий.Вставить("СтраницаЗначенийКатегорий", "СтраницаПустая");
			КонецЕсли;
		ИначеЕсли (ТипЗнч(СтруктураПараметров.ТипЗначения) = ТипТип) Тогда
			Если СтруктураПараметров.ТипЗначения = ТипЗначениеКатегорииНовостей Тогда
				СтруктураДействий.Вставить("СтраницаЗначенийКатегорий", "СтраницаСправочник");
			Иначе
				СтруктураДействий.Вставить("СтраницаЗначенийКатегорий", "СтраницаПустая");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	Если СтруктураПараметров.ОбновляетсяССервера = Истина Тогда
		// Все действия можно сделать на клиенте.
	КонецЕсли;

	Возврат СтруктураДействий;

КонецФункции

&НаСервере
// Процедура обновляет все информационные надписи.
//
// Параметры:
//  Нет.
//
Процедура ОбновитьИнформационныеСтроки()

	Если Объект.Ссылка.Пустая() Тогда
		Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок  = ""; // Необходимо вначале записать
		Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
	Иначе
		Если Объект.ОбновляетсяССервера Тогда

			// Проверка необходимости обновления и вывод сообщения в декорации. Начало.

			ТребуетсяОбновление = Ложь;

			Запись = РегистрыСведений.ДатыОбновленияСтандартныхСписковНовостей.СоздатьМенеджерЗаписи();
			Запись.Список = Объект.Ссылка;
			Запись.Прочитать(); // Только чтение, без последующей записи.

			Если Запись.Выбран() Тогда
				Если Запись.ТекущаяВерсияНаКлиенте >= Запись.ТекущаяВерсияНаСервере Тогда
					ТекстНадписи = НСтр("ru='Данные актуальны и соответствуют данным с сервера от %ТекущаяВерсияНаСервере%.'");
					ТекстНадписи = СтрЗаменить(ТекстНадписи, "%ТекущаяВерсияНаСервере%", Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
					ТребуетсяОбновление = Ложь;
				Иначе // Устарели
					Если Запись.ТекущаяВерсияНаКлиенте = '00010101' Тогда
						ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера,
							|а на сервере уже версия от %ТекущаяВерсияНаСервере%.'");
					Иначе
						ТекстНадписи = НСтр("ru='Последний раз данные обновлялись с сервера %ТекущаяВерсияНаКлиенте%,
							|а на сервере уже версия от %ТекущаяВерсияНаСервере%.'");
					КонецЕсли;
					ТекстНадписи = СтрЗаменить(ТекстНадписи, "%ТекущаяВерсияНаКлиенте%", Формат(Запись.ТекущаяВерсияНаКлиенте, "ДЛФ=DT"));
					ТекстНадписи = СтрЗаменить(ТекстНадписи, "%ТекущаяВерсияНаСервере%", Формат(Запись.ТекущаяВерсияНаСервере, "ДЛФ=DT"));
					ТребуетсяОбновление = Истина;
				КонецЕсли;
			Иначе
				ТекстНадписи = НСтр("ru='Данные никогда не обновлялись с сервера.'");
				ТребуетсяОбновление = Истина;
			КонецЕсли;

			Если ПолучитьФункциональнуюОпцию("РазрешенаРаботаСНовостямиЧерезИнтернет") = Истина Тогда
				Если (ЭтотОбъект.РольДоступнаАдминистратор = Истина) Тогда
					// Если эта форма открыта из формы обработки "Управление новостями", то
					//  не давать снова открывать форму обработки.
					Если ЭтотОбъект.ОткрытаИзОбработки_УправлениеНовостями = Истина Тогда
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
					Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок = ТекстНадписи;
					Если ТребуетсяОбновление = Истина Тогда
						Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветОсобогоТекста;
					Иначе
						Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;

			// Проверка необходимости обновления и вывод сообщения в декорации. Конец.

		Иначе
			Элементы.ДекорацияТребуетсяОбновлениеССервера.Заголовок  = НСтр("ru='Данные вводятся вручную и обновление с сервера не требуется.'");
			Элементы.ДекорацияТребуетсяОбновлениеССервера.ЦветТекста = ЦветаСтиля.ЦветМикротекста;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

#КонецОбласти
