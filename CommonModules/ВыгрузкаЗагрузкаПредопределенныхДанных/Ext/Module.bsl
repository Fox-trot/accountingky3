﻿#Область СлужебныйПрограммныйИнтерфейс

// Заполняет массив типов, для которых при выгрузке необходимо использовать аннотацию
// ссылок в файлах выгрузки.
//
// Параметры:
//  Типы - Массив Из ОбъектМетаданных - объекты метаданных. 
//
Процедура ПриЗаполненииТиповТребующихАннотациюСсылокПриВыгрузке(Типы) Экспорт
	
	ОбъектыСПредопределеннымиЭлементами = ВыгрузкаЗагрузкаПредопределенныхДанныхПовтИсп.ОбъектыМетаданныхСПредопределеннымиЭлементами();
	Для Каждого ИмяТипа Из ОбъектыСПредопределеннымиЭлементами Цикл
		
		Если ТребуетсяСопоставлениеСсылокНаПредопределенныеЭлементы(ИмяТипа) Тогда
			Типы.Добавить(Метаданные.НайтиПоПолномуИмени(ИмяТипа));
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при регистрации произвольных обработчиков выгрузки данных.
// В данной процедуре требуется дополнить эту таблицу значений информацией 
// о регистрируемых произвольных обработчиках выгрузки данных.
// 
// Параметры:
//	ТаблицаОбработчиков - ТаблицаЗначений - колонки:
//	 * ОбъектМетаданных - ОбъектМетаданных - при выгрузке данных которого должен вызываться регистрируемый обработчик,
//	 * Обработчик - ОбщийМодуль - общий модуль, в котором реализован произвольный обработчик выгрузки данных. 
//	    Набор экспортных процедур, которые должны быть реализованы в обработчике, зависит от установки значений 
//	    следующих колонок таблицы значений.
//	 * Версия - Строка - номер версии интерфейса обработчиков выгрузки / загрузки данных, поддерживаемого обработчиком.
//	 * ПередВыгрузкойТипа - Булево - флаг необходимости вызова обработчика перед выгрузкой всех объектов информационной
//	    базы, относящихся к данному объекту метаданных. Если присвоено значение Истина - в общем модуле обработчика 
//	    должна быть реализована экспортируемая процедура ПередВыгрузкойТипа(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера, используемый 
//          в процессе выгрузи данных. Подробнее см. комментарий к программному интерфейсу обработки. 
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения аннотации ссылок. В случае, 
//          если в произвольном обработчике выгрузки требуется выполнять выгрузку дополнительных данных - следует 
//          использовать СериализаторXDTO, переданный в процедуру ПередВыгрузкойТипа() в качестве значения параметра 
//          Сериализатор, а не полученных с помощью свойства глобального контекста СериализаторXDTO.
//        ОбъектМетаданных - ОбъектМетаданных - перед выгрузкой данных которого был вызван обработчик.
//        Отказ - Булево - если в процедуре ПередВыгрузкойТипа() установить значение данного параметра равным 
//          Истина - выгрузка объектов, соответствующих текущему объекту метаданных, выполняться не будет.
//	 * ПередВыгрузкойОбъекта - Булево - флаг необходимости вызова обработчика перед выгрузкой конкретного объекта 
//	    информационной базы. Если присвоено значение Истина - в общем модуле обработчика должна быть реализована 
//	    экспортируемая процедура ПередВыгрузкойОбъекта(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера, используемый 
//          в процессе выгрузи данных. Подробнее см. комментарий к программному интерфейсу обработки.
//        МенеджерВыгрузкиОбъекта - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы -
//          менеджер выгрузки текущего объекта. Подробнее см. комментарий к программному интерфейсу обработки
//          ВыгрузкаЗагрузкаДанныхМенеджерВыгрузкиДанныхИнформационнойБазы. Параметр передается только при вызове
//          процедур обработчиков, для которых при регистрации указана версия не ниже 1.0.0.1.
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения аннотации ссылок. В случае, 
//          если в произвольном обработчике выгрузки требуется выполнять выгрузку дополнительных данных - следует 
//          использовать СериализаторXDTO, переданный в процедуру ПередВыгрузкойОбъекта() в качестве значения 
//          параметра Сериализатор, а не полученных с помощью свойства глобального контекста СериализаторXDTO.
//        Объект - КонстантаМенеджерЗначения, СправочникОбъект, ДокументОбъект, БизнесПроцессОбъект, ЗадачаОбъект, 
//          ПланСчетовОбъект, ПланОбменаОбъект, ПланВидовХарактеристикОбъект, ПланВидовРасчетаОбъект, 
//          РегистрСведенийНаборЗаписей, РегистрНакопленияНаборЗаписей, РегистрБухгалтерииНаборЗаписей,
//          РегистрРасчетаНаборЗаписей, ПоследовательностьНаборЗаписей, ПерерасчетНаборЗаписей - объект данных 
//          информационной базы, перед выгрузкой которого был вызван обработчик. Значение, переданное в процедуру 
//          ПередВыгрузкойОбъекта() в качестве значения параметра Объект может быть модифицировано внутри обработчика 
//          ПередВыгрузкойОбъекта(), при этом внесенные изменения будут отражены в сериализации объекта в файлах 
//          выгрузки, но не будут зафиксированы в информационной базе
//        Артефакты - Массив Из ОбъектXDTO - набор дополнительной информации, логически неразрывно связанной с объектом,
//          но не являющейся его частью (артефакты объекта). Артефакты должны сформированы внутри обработчика 
//          ПередВыгрузкойОбъекта() и добавлены в массив, переданный в качестве значения параметра Артефакты. 
//          Каждый артефакт должен являться XDTO-объектом, для типа которого в качестве базового типа используется 
//          абстрактный XDTO-тип {http://www.1c.ru/1cFresh/Data/Dump/1.0.2.1}Artefact. Допускается использовать 
//          XDTO-пакеты, помимо изначально поставляемых в составе подсистемы ВыгрузкаЗагрузкаДанных. В дальнейшем
//          артефакты, сформированные в процедуре ПередВыгрузкойОбъекта(), будут доступны в процедурах
//          обработчиков загрузки данных (см. комментарий к процедуре ПриРегистрацииОбработчиковЗагрузкиДанных().
//        Отказ - Булево - если в процедуре ПередВыгрузкойОбъекта() установить значение данного параметра 
//        равным Истина - выгрузка объекта, для которого был вызван обработчик, выполняться не будет.
//	 * ПослеВыгрузкиТипа - Булево - флаг необходимости вызова обработчика после выгрузки всех объектов информационной 
//	    базы, относящихся к данному объекту метаданных. Если присвоено значение Истина - в общем модуле обработчика 
//	    должна быть реализована экспортируемая процедура ПослеВыгрузкиТипа(), поддерживающая следующие параметры:
//        Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера, используемый 
//          в процессе выгрузи данных. Подробнее см. комментарий к программному интерфейсу обработки.
//        Сериализатор - СериализаторXDTO - инициализированный с поддержкой выполнения аннотации ссылок. В случае, 
//          если в произвольном обработчике выгрузки требуется выполнять выгрузку дополнительных данных - следует 
//          использовать СериализаторXDTO, переданный в процедуру ПослеВыгрузкиТипа() в качестве значения параметра 
//          Сериализатор, а не полученных с помощью свойства глобального контекста СериализаторXDTO,
//        ОбъектМетаданных - ОбъектМетаданных - после выгрузки данных которого был вызван обработчик.
//
Процедура ПриРегистрацииОбработчиковВыгрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	ОбъектыСПредопределеннымиЭлементами = ВыгрузкаЗагрузкаПредопределенныхДанныхПовтИсп.ОбъектыМетаданныхСПредопределеннымиЭлементами();
	Для Каждого ИмяОбъектаМетаданных Из ОбъектыСПредопределеннымиЭлементами Цикл
		
		Если ТребуетсяСопоставлениеСсылокНаПредопределенныеЭлементы(ИмяОбъектаМетаданных) Тогда
			
			НовыйОбработчик = ТаблицаОбработчиков.Добавить();
			НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
			НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаПредопределенныхДанных;
			НовыйОбработчик.ПослеВыгрузкиОбъекта = Истина;
			НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПослеВыгрузкиОбъекта(Контейнер, МенеджерВыгрузкиОбъекта, Сериализатор, Объект, Артефакты) Экспорт
	
	МетаданныеОбъекта = Объект.Метаданные();
	Если ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(Объект.Метаданные()) Тогда
		
		Если ТребуетсяСопоставлениеСсылокНаПредопределенныеЭлементы(МетаданныеОбъекта.ПолноеИмя()) Тогда
			
			Если Объект.Предопределенный Тогда
				
				ЕстественныйКлюч = Новый Структура("ИмяПредопределенныхДанных", Объект.ИмяПредопределенныхДанных);
				МенеджерВыгрузкиОбъекта.ТребуетсяСопоставитьСсылкуПриЗагрузке(Объект.Ссылка, ЕстественныйКлюч);
				
			КонецЕсли;
			
		Иначе
			
			ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком
                  |ВыгрузкаЗагрузкаПредопределенныхДанных.ПередВыгрузкойОбъекта(),
                  |т.к. не требуется обеспечивать сопоставление ссылок на его предопределенные элементы.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			МетаданныеОбъекта.ПолноеИмя());
			
		КонецЕсли;
		
	Иначе
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком
                  |ВыгрузкаЗагрузкаПредопределенныхДанных.ПередВыгрузкойОбъекта(),
                  |т.к. не может содержать предопределенных элементов.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			МетаданныеОбъекта.ПолноеИмя());
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередОчисткойДанных(Контейнер) Экспорт
	
	УстановитьИнициализациюПредопределенныхДанныхТекущейОбластиДанных(Контейнер.ПараметрыЗагрузки().ЗагружаемыеТипы);
	
КонецПроцедуры

// Параметры:
// 	ТаблицаОбработчиков - см. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриРегистрацииОбработчиковЗагрузкиДанных.ТаблицаОбработчиков
Процедура ПриРегистрацииОбработчиковЗагрузкиДанных(ТаблицаОбработчиков) Экспорт
	
	НовыйОбработчик = ТаблицаОбработчиков.Добавить();
	НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаПредопределенныхДанных;
	НовыйОбработчик.ПередОчисткойДанных = Истина;
	НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
	
	ОбъектыСПредопределеннымиЭлементами = ВыгрузкаЗагрузкаПредопределенныхДанныхПовтИсп.ОбъектыМетаданныхСПредопределеннымиЭлементами();
	Для Каждого ИмяОбъектаМетаданных Из ОбъектыСПредопределеннымиЭлементами Цикл
		
		Если ТребуетсяСопоставлениеСсылокНаПредопределенныеЭлементы(ИмяОбъектаМетаданных) Тогда
			
			НовыйОбработчик = ТаблицаОбработчиков.Добавить();
			НовыйОбработчик.ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ИмяОбъектаМетаданных);
			НовыйОбработчик.Обработчик = ВыгрузкаЗагрузкаПредопределенныхДанных;
			НовыйОбработчик.ПередСопоставлениемСсылок = Истина;
			НовыйОбработчик.ПередЗагрузкойОбъекта = Истина;
			НовыйОбработчик.Версия = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ВерсияОбработчиков1_0_0_1();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Параметры:
// 	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера.
// 	ОбъектМетаданных - ОбъектМетаданных - объект метаданных.
// 	ТаблицаИсходныхСсылок - ТаблицаЗначений - таблица ссылок.
// 	СтандартнаяОбработка - Булево - признак страндартной обработки.
// 	Отказ - Булево - признак отказа от обработки.
Процедура ПередСопоставлениемСсылок(Контейнер, ОбъектМетаданных, ТаблицаИсходныхСсылок, СтандартнаяОбработка, Отказ) Экспорт
	
	Если ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектМетаданных)
			И ТаблицаИсходныхСсылок.Колонки.Найти("ИмяПредопределенныхДанных") <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//	Контейнер - ОбработкаОбъект.ВыгрузкаЗагрузкаДанныхМенеджерКонтейнера - менеджер контейнера, используемый в процессе 
//	 загрузки данных. Подробнее см. комментарий к программному интерфейсу обработки.
//	ТаблицаИсходныхСсылок - ТаблицаЗначений - содержащая информацию о ссылках, выгруженных из исходной ИБ. Колонки:
//	* ИсходнаяСсылка - ЛюбаяСсылка - ссылка объекта исходной ИБ, которую требуется сопоставить c ссылкой в текущей ИБ,
//		Остальные колонки равным полям естественного ключа объекта.
// Возвращаемое значение:
//	ТаблицаЗначений - колонки:
//	 * ИсходнаяСсылка - ЛюбаяСсылка -  ссылка объекта, выгруженная из исходной ИБ,
//	 * Ссылка - ЛюбаяСсылка - сопоставленная исходной ссылка в текущей ИБ.
Функция СопоставитьСсылки(Контейнер, МенеджерСопоставленияСсылок, ТаблицаИсходныхСсылок) Экспорт
	
	ИсходныеСсылкиДляСтандартнойОбработки = Новый ТаблицаЗначений();
	Для Каждого Колонка Из ТаблицаИсходныхСсылок.Колонки Цикл
		Если Колонка.Имя <> "ИмяПредопределенныхДанных" Тогда
			ИсходныеСсылкиДляСтандартнойОбработки.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		КонецЕсли;
	КонецЦикла;
	
	ИмяКолонки = МенеджерСопоставленияСсылок.ИмяКолонкиИсходныхСсылок();
	
	Результат = Новый ТаблицаЗначений();
	Результат.Колонки.Добавить(ИмяКолонки, ТаблицаИсходныхСсылок.Колонки.Найти(ИмяКолонки).ТипЗначения);
	Результат.Колонки.Добавить("Ссылка", ТаблицаИсходныхСсылок.Колонки.Найти(ИмяКолонки).ТипЗначения);
	
	ОбъектМетаданных = Неопределено;
	
	Для Каждого СтрокаТаблицыИсходныхСсылок Из ТаблицаИсходныхСсылок Цикл
		
		Если ЗначениеЗаполнено(СтрокаТаблицыИсходныхСсылок.ИмяПредопределенныхДанных) Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
				"ВЫБРАТЬ
				|	Таблица.Ссылка КАК Ссылка
				|ИЗ
				|	&ТаблицаСсылок КАК Таблица
				|ГДЕ
				|	Таблица.ИмяПредопределенныхДанных = &ИмяПредопределенныхДанных";
			Запрос.УстановитьПараметр("ИмяПредопределенныхДанных", СтрокаТаблицыИсходныхСсылок.ИмяПредопределенныхДанных);
			ОбъектМетаданных = СтрокаТаблицыИсходныхСсылок[ИмяКолонки].Метаданные(); // ОбъектМетаданных
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТаблицаСсылок", ОбъектМетаданных.ПолноеИмя());
			РезультатЗапроса = Запрос.Выполнить();
			Если Не РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				
				Если Выборка.Количество() = 1 Тогда
					
					Выборка.Следующий();
					
					СтрокаРезультата = Результат.Добавить();
					СтрокаРезультата.Ссылка = Выборка.Ссылка;
					СтрокаРезультата[ИмяКолонки] = СтрокаТаблицыИсходныхСсылок[ИмяКолонки];
					
				Иначе
					
					ВызватьИсключение СтрШаблон(
						НСтр("ru = 'Обнаружено дублирование предопределенных элементов %1 в таблице %2.'", Метаданные.ОсновнойЯзык.КодЯзыка),
						СтрокаТаблицыИсходныхСсылок.ИмяПредопределенныхДанных,
						ОбъектМетаданных.ПолноеИмя());
					
				КонецЕсли;
				
			КонецЕсли;
			
		Иначе
			
			Если ОбъектМетаданных = Неопределено Тогда
				ОбъектМетаданных = СтрокаТаблицыИсходныхСсылок[ИмяКолонки].Метаданные();
			КонецЕсли;
			
			СсылкаДляСтандартнойОбработки = ИсходныеСсылкиДляСтандартнойОбработки.Добавить();
			ЗаполнитьЗначенияСвойств(СсылкаДляСтандартнойОбработки, СтрокаТаблицыИсходныхСсылок);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ИсходныеСсылкиДляСтандартнойОбработки.Количество() > 0 Тогда
		
		Выборка = Обработки.ВыгрузкаЗагрузкаДанныхМенеджерСопоставленияСсылок.ВыборкаСопоставленияСсылок(
			ОбъектМетаданных, ИсходныеСсылкиДляСтандартнойОбработки, ИмяКолонки);
		
		Пока Выборка.Следующий() Цикл
			
			СтрокаРезультата = Результат.Добавить();
			СтрокаРезультата.Ссылка = Выборка.Ссылка;
			СтрокаРезультата[ИмяКолонки] = Выборка[ИмяКолонки];
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Процедура ПередЗагрузкойОбъекта(Контейнер, Объект, Артефакты, Отказ) Экспорт
	
	ОбъектМетаданных = Объект.Метаданные(); // ОбъектМетаданных
	
	Если НЕ ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектМетаданных) Тогда
		
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Объект метаданных %1 не может быть обработан обработчиком
                  |ВыгрузкаЗагрузкаПредопределенныхДанных.ПередЗагрузкойОбъекта(),
                  |т.к. не может содержать предопределенных элементов.'", Метаданные.ОсновнойЯзык.КодЯзыка),
			ОбъектМетаданных.ПолноеИмя());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьИнициализациюПредопределенныхДанныхТекущейОбластиДанных(ОбъектыМетаданных)
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		
		Если ОбщегоНазначенияБТС.ЭтоСсылочныеДанныеПоддерживающиеПредопределенныеЭлементы(ОбъектМетаданных) Тогда
			
			Если ОбъектМетаданных.ПолучитьИменаПредопределенных().Количество() > 0 Тогда
				
				Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
				Менеджер.УстановитьИнициализациюПредопределенныхДанных(Истина);
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ТребуетсяСопоставлениеСсылокНаПредопределенныеЭлементы(ИмяТипа)
	
	Если РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяТипа, РаботаВМоделиСервиса.РазделительОсновныхДанных())
		ИЛИ РаботаВМоделиСервиса.ЭтоРазделенныйОбъектМетаданных(ИмяТипа, РаботаВМоделиСервиса.РазделительВспомогательныхДанных()) Тогда
		
		Возврат Ложь;
			
	Иначе
		
		// Для неразделенных объектов сопоставление ссылок на предопределенные элементы требуется всегда.
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти