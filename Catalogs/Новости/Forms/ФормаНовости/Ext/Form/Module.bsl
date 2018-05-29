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

	ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Ложь;

	// В конфигурации есть общие реквизиты с разделением и включена ФО РаботаВМоделиСервиса.
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Зашли в конфигурацию под пользователем без разделения (и не вошли в область данных).
		Если ИнтернетПоддержкаПользователей.СеансЗапущенБезРазделителей() Тогда
			Элементы.ГруппаКоманднаяПанель.Видимость = Ложь;
			ПолучитьТекущегоПользователя = Ложь;
			ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина;
		Иначе
			ПолучитьТекущегоПользователя = Истина;
		КонецЕсли;
	Иначе
		ПолучитьТекущегоПользователя = Истина;
	КонецЕсли;

	Если ПолучитьТекущегоПользователя = Истина Тогда
		ПараметрыСеанса_ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Иначе
		ПараметрыСеанса_ТекущийПользователь = Справочники.Пользователи.ПустаяСсылка();
	КонецЕсли;

	лкТекущаяУниверсальнаяДата = ТекущаяУниверсальнаяДата();

	// Новости не должны создаваться - только читаться, поэтому если Ключ не заполнен, то форму не открывать.
	Если Параметры.Ключ.Пустая() Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru='В справочнике новостей нельзя создавать новости вручную.
			|Используйте загрузку новостей из лент новостей.'");
		Сообщение.Сообщить();
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	Если ВРег(Параметры.РежимОткрытияОкна) = ВРег("БлокироватьОкноВладельца") Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	Иначе // Все остальные значения
		// По-умолчанию - независимое открытие.
	КонецЕсли;

	Если (Параметры.ПоказыватьПанельНавигации = Истина)
			И (ОбработкаНовостейПовтИсп.ЕстьРолиЧтенияНовостей()) Тогда
		Элементы.ГруппаНавигация.Видимость = Истина;
	Иначе
		Элементы.ГруппаНавигация.Видимость = Ложь;
	КонецЕсли;

	// Заполнение реквизитов для новости, требующей прочтения.
	// Если новость важная или очень важная, то признак прочтенности имеет особое значение и означает,
	// что новость больше не должна назойливо всплывать.
	// Поэтому для простой новости прочтенность можно устанавливать уже на этапе создания окна, а для
	//  важных и очень важных новостей - только пользователем.

	// Определить, установлена ли важность для контекстного представления новости?
	УстановленаВажностьДляКонтекстнойНовости = Ложь;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда
		Для каждого ТекущаяПривязкаКМетаданным Из Объект.ПривязкаКМетаданным Цикл
			// Важность для контекстной новости установлена?
			Если (ТекущаяПривязкаКМетаданным.Важность = 1)
					ИЛИ (ТекущаяПривязкаКМетаданным.Важность = 2) Тогда
				// Дата сброса важности установлена? Сброс важности наступил?
				Если (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности = '00010101')
						ИЛИ (ТекущаяПривязкаКМетаданным.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
					УстановленаВажностьДляКонтекстнойНовости = Истина;
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

	// Если ДатаСбросаВажности пустая или >= ТекущаяУниверсальнаяДата(), то важность имеет значение, иначе Важность = 0.
	ВажностьНаТекущуюДату = 0;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
		Если (Объект.ДатаСбросаВажности = '00010101')
				ИЛИ (Объект.ДатаСбросаВажности > лкТекущаяУниверсальнаяДата) Тогда
			ВажностьНаТекущуюДату = Объект.Важность;
		КонецЕсли;
	КонецЕсли;

	ТребуетПрочтения = Ложь;
	Если (Объект.ДатаЗавершения = '00010101')
			ИЛИ (Объект.ДатаЗавершения > лкТекущаяУниверсальнаяДата) Тогда // Новость еще актуальна?
		Если (ВажностьНаТекущуюДату = 1)
				ИЛИ (ВажностьНаТекущуюДату = 2)
				ИЛИ (УстановленаВажностьДляКонтекстнойНовости = Истина) Тогда
			ТребуетПрочтения = Истина;
		КонецЕсли;
	КонецЕсли;

	Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости = Истина Тогда
		ПрочтенаПриОткрытии           = Истина;
		ДатаНачалаОповещения          = '00010101';
		ОповещениеВключено            = Ложь;
		Пометка                       = 0;
		ОповещениеВключеноПриОткрытии = Ложь;
	Иначе
		// Загрузить из базы состояние новости:
		//  - Прочтена;
		//  - Пометка;
		//  - ОповещениеВключено (имеет смысл только для важных и очень важных новостей);
		//  - ДатаНачалаОповещения (имеет смысл только для важных и очень важных новостей) // Пока не появится кнопка Отложить, всегда = пустой дате.
		Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
		Запись.Пользователь = ПараметрыСеанса_ТекущийПользователь;
		Запись.Новость      = Объект.Ссылка;
		Запись.Прочитать(); // Только чтение, без последующей записи.
		Если Запись.Выбран() Тогда
			ПрочтенаПриОткрытии           = Запись.Прочтена; // Для определения (при закрытии формы) - надо ли делать запись в регистр сведений.
			ДатаНачалаОповещения          = Запись.ДатаНачалаОповещения;
			ОповещениеВключено            = Запись.ОповещениеВключено;
			Пометка                       = Запись.Пометка;
			ОповещениеВключеноПриОткрытии = ОповещениеВключено;
		Иначе
			ПрочтенаПриОткрытии   = Ложь; // Для определения при закрытии - надо ли делать запись в регистр сведений.
			ОповещениеВключеноПриОткрытии = Ложь;
			Если ТребуетПрочтения = Истина Тогда
				Если Объект.АвтоСбросНапоминанияПриПрочтении = Истина Тогда
					ОповещениеВключено = Ложь;
				Иначе
					ОповещениеВключено = Истина;
				КонецЕсли;
			Иначе
				ОповещениеВключено = Ложь;
			КонецЕсли;
			ДатаНачалаОповещения = '00010101';
			Пометка = 0;
		КонецЕсли;
		Прочтена = Истина; // При открытии признак Прочтена = Истина всегда, вне зависимости от сохраненного состояния новости.
		ПометкаПриОткрытии = Пометка;
	КонецЕсли;

	// Если новость уже неактуальна, но была установлена важность, то сбросить признак оповещения.
	Если (Объект.ДатаЗавершения <> '00010101')
			И (Объект.ДатаЗавершения <= лкТекущаяУниверсальнаяДата)
			И (ОповещениеВключено = Истина) Тогда // Новость уже неактуальна, но было включено оповещение.
		ОповещениеВключено = Ложь;
		СостояниеНовостиИзменено = Истина; // Принудительно установить признак, чтобы при закрытии записалось новое состояние.
	КонецЕсли;

	// Если флажок ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка на полный текст новости
	//  в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(Объект.СсылкаНаПолныйТекстНовости) Тогда
			// Отметить такую новость как прочтенную и сбросить признак оповещения сразу,
			//  т.к. формы для просмотра у этой новости (где можно нажать кнопку "Прочтено" / "Оповещение") нет.
			// Записывать настройки нельзя при работе разделенной конфигурации в неразделенном сеансе.
			Если ПропуститьЧтениеЗаписьПользовательскихНастроекНовости <> Истина Тогда
				ЗаписатьИзменениеСостоянияНовостиСервер(
					Объект.Ссылка,
					Истина, // ЭтотОбъект.Прочтена,
					Пометка,
					Ложь, // ЭтотОбъект.ОповещениеВключено,
					'00010101', // ЭтотОбъект.ДатаНачалаОповещения
					ПараметрыСеанса_ТекущийПользователь);
			КонецЕсли;
			// Прервать открытие формы.
			СтандартнаяОбработка = Ложь;
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если ТребуетПрочтения = Истина Тогда
		Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьТребуетПрочтения;
	Иначе
		Элементы.СтраницыКнопокНапоминания.ТекущаяСтраница = Элементы.СтраницаНовостьНеТребуетПрочтения;
	КонецЕсли;

	// Текст новости.
	ТекстНовости = ОбработкаНовостейПовтИсп.ПолучитьХТМЛТекстНовостей(Объект.Ссылка);
	Заголовок = Объект.Наименование;
	ИдентификаторМеста = Параметры.ИдентификаторМеста;

	ОбработкаНовостейПереопределяемый.ДополнительноОбработатьФормуНовостиПриСозданииНаСервере(
		ЭтотОбъект,
		Отказ,
		СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	// Если ПриОткрытииСразуПереходитьПоСсылке = Истина и задана ссылка
	//  на полный текст новости в реквизите СсылкаНаПолныйТекстНовости, то не открывать форму, а сразу перейти по ссылке.
	// Причем, ссылка может вести как на внешний сайт, так и на объекты метаданных,
	//  разделы справки и т.п. (если начинается на "1C:" английскими буквами).
	// Подробности см. в ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки.
	НавигационнаяСсылка = Объект.СсылкаНаПолныйТекстНовости;
	Если Объект.ПриОткрытииСразуПереходитьПоСсылке = Истина Тогда
		Если НЕ ПустаяСтрока(НавигационнаяСсылка) Тогда

			// Некоторые браузеры (например, FF33) добавляют полный адрес к параметру href и тогда вместо "1C:Act001" получается "http://ПутьКБазе/1C:Act001".
			Если СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ГдеРазделитель1С = СтрНайти(ВРег(НавигационнаяСсылка), ВРег("/1C:"));
				Если ГдеРазделитель1С > 0 Тогда // 1C - "С" - английская
					НавигационнаяСсылка = Прав(НавигационнаяСсылка, СтрДлина(НавигационнаяСсылка) - ГдеРазделитель1С);
				КонецЕсли;
			КонецЕсли;

			Если СтрНайти(ВРег(НавигационнаяСсылка), ВРег("http")) = 1 Тогда
				ОбработкаНовостейКлиент.ПерейтиПоИнтернетСсылке(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1c://")) = 1 Тогда
				ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("e1cib/")) = 1 Тогда
				ОбщегоНазначенияКлиент.ОткрытьНавигационнуюСсылку(НавигационнаяСсылка);
				Отказ = Истина;
				Возврат;
			ИначеЕсли СтрНайти(ВРег(НавигационнаяСсылка), ВРег("1C:")) = 1 Тогда // 1C - "С" - английская
				// Запустить ОбработкаНавигационнойСсылки с параметрами.
				Действие = "";
				СписокПараметров = Неопределено;
				ОбработкаНовостейВызовСервера.ПодготовитьПараметрыНавигационнойСсылки(Объект.Ссылка, НавигационнаяСсылка, Действие, СписокПараметров);
				ОбработкаНовостейКлиент.ОбработкаНавигационнойСсылки(Объект.Ссылка, Неопределено, Действие, СписокПараметров);
				Отказ = Истина;
				Возврат;
			Иначе
				ТекстСообщения = НСтр("ru='Неизвестная ссылка: %НавигационнаяСсылка%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НавигационнаяСсылка%", НавигационнаяСсылка);
				ПоказатьПредупреждение(
					, // ОписаниеОповещенияОЗавершении
					ТекстСообщения,
					0,
					НСтр("ru='Ошибка'")); 
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ЭтотОбъект.ПодключитьОбработчикОжидания("Подключаемый_АктивизироватьФорму", 0.2, Истина);

	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)

	Если ЗавершениеРаботы = Истина Тогда
		// Запрещены серверные вызовы и открытие форм.
		// В таком исключительном случае, когда выходят из программы,
		//  можно проигнорировать установку признака прочтенности у новостей.
	Иначе

		// Если включено разделение данных, и мы зашли в неразделенном сеансе,
		//  то нельзя устанавливать пользовательские свойства новости.
		// Определить, как мы зашли, можно по отключенной командной панели.
		Если Элементы.ГруппаКоманднаяПанель.Видимость = Ложь Тогда
			Возврат;
		КонецЕсли;

		Если Прочтена <> ПрочтенаПриОткрытии Тогда
			СостояниеНовостиИзменено = Истина;
			Оповестить(
				"Новости. Новость прочтена",
				Прочтена,
				Объект.Ссылка);
		КонецЕсли;

		Если ТребуетПрочтения = Истина Тогда
			Если ОповещениеВключено <> ОповещениеВключеноПриОткрытии Тогда
				СостояниеНовостиИзменено = Истина;
				Оповестить(
					"Новости. Изменено состояние оповещения о новости",
					ОповещениеВключено,
					Объект.Ссылка);
				// Для новостей с изменившимся признаком Оповещение очистить кэш контекстных новостей.
				// Причем не имеет значения - включили признак, или выключили.
				Для Каждого ПараметрыКонтекстнойНовости Из Объект.ПривязкаКМетаданным Цикл
					ОбработкаНовостейКлиент.УдалитьКонтекстныеНовостиИзКэшаПриложения(
						ПараметрыКонтекстнойНовости.Метаданные,
						ПараметрыКонтекстнойНовости.Форма);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;

		Если Пометка <> ПометкаПриОткрытии Тогда
			СостояниеНовостиИзменено = Истина;
			МассивНовостей = Новый Массив;
			МассивНовостей.Добавить(Объект.Ссылка);
			Оповестить(
				"Новости. Изменена пометка списка новостей",
				Пометка,
				МассивНовостей);
		КонецЕсли;

		Если СостояниеНовостиИзменено = Истина Тогда
			Если НЕ ПараметрыСеанса_ТекущийПользователь.Пустая() Тогда
				ЗаписатьИзменениеСостоянияНовостиСервер(
					Объект.Ссылка,
					Прочтена,
					Пометка,
					ОповещениеВключено,
					ДатаНачалаОповещения,
					ПараметрыСеанса_ТекущийПользователь);
			КонецЕсли;
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	ОбработкаНовостейКлиент.ПросмотрНовости_ОбработкаОповещения(ИмяСобытия, Параметр, Источник, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстНовостиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)

	лкОбъект = Объект; // При открытии из формы элемента справочника / документа

	ОбработкаНовостейКлиент.ОбработкаНажатияВТекстеНовости(лкОбъект, ДанныеСобытия, СтандартнаяОбработка, ЭтотОбъект, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ТекстНовостиДокументСформирован(Элемент)

	Если НЕ ПустаяСтрока(ИдентификаторМеста) Тогда
		Попытка
			ЭлементЯкорь = Элементы.ТекстНовости.Документ.getElementByID(ИдентификаторМеста);
			Если ЭлементЯкорь <> Неопределено Тогда
				// Отображать элемент сверху экрана.
				ЭлементЯкорь.ScrollIntoView(Истина); // Не все браузеры поддерживают этот метод.
			КонецЕсли;
		Исключение
			// Не все браузеры поддерживают метод ScrollIntoView.
		КонецПопытки;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПометкаНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Если Пометка > 0 Тогда
		Пометка = 0;
	Иначе
		Пометка = 1;
	КонецЕсли;
	УправлениеФормой();

КонецПроцедуры

&НаКлиенте
Процедура ОповещениеВключеноПриИзменении(Элемент)

	УправлениеФормой();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Управление видимостью и доступностью элементов формы.
//
&НаКлиенте
Процедура УправлениеФормой()

	Если Пометка = 0 Тогда
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Выпуклая);
		Элементы.Пометка.Подсказка = НСтр("ru='Новость не отмечена'");
	Иначе
		Элементы.Пометка.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Вдавленная);
		Элементы.Пометка.Подсказка = НСтр("ru='Новость отмечена'");
	КонецЕсли;

	Если ОповещениеВключено Тогда
		Элементы.СтраницыКартинкиОповещения.ТекущаяСтраница = Элементы.СтраницаОповещениеВключено;
	Иначе
		Элементы.СтраницыКартинкиОповещения.ТекущаяСтраница = Элементы.СтраницаОповещениеОтключено;
	КонецЕсли;

КонецПроцедуры

// Активизирует окно формы, на случай если оно перекрылось другими формами.
//
&НаКлиенте
Процедура Подключаемый_АктивизироватьФорму()

	ЭтотОбъект.Активизировать();

КонецПроцедуры

&НаСервереБезКонтекста
// Процедура записывает регистр сведений "СостоянияНовостей".
//
// Параметры:
//  НовостьСсылка          - СправочникСсылка.Новости;
//  лкПрочтена             - Булево;
//  лкПометка              - Число (1,0);
//  лкОповещениеВключено   - Булево;
//  лкДатаНачалаОповещения - Дата;
//  лкТекущийПользователь  - СправочникСсылка.Пользователи.
//
Процедура ЗаписатьИзменениеСостоянияНовостиСервер(
			НовостьСсылка,
			лкПрочтена,
			лкПометка,
			лкОповещениеВключено,
			лкДатаНачалаОповещения,
			лкТекущийПользователь)

	Запись = РегистрыСведений.СостоянияНовостей.СоздатьМенеджерЗаписи();
	Запись.Пользователь = лкТекущийПользователь;
	Запись.Новость      = НовостьСсылка;
	Запись.Прочитать(); // Запись будет ниже. // На тот случай, если были установлены другие свойства.
	// Вдруг новость не выбрана (т.е. ее нет в базе) - перезаполнить менеджер записи и записать.
	Запись.Пользователь         = лкТекущийПользователь;
	Запись.Новость              = НовостьСсылка;
	Запись.Прочтена             = лкПрочтена;
	Запись.Пометка              = лкПометка;
	Запись.ОповещениеВключено   = лкОповещениеВключено;
	Запись.ДатаНачалаОповещения = лкДатаНачалаОповещения;
	Запись.Записать(Истина);

КонецПроцедуры

#КонецОбласти

