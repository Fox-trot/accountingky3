﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Помещает во временное хранилище подготовленную структуру для просмотра метаданных
//
// Параметры:
//  Параметры		 - Структура - Пустая структура. Наличие параметра обусловлено использованием в подсистеме ДлительныеОперации
//  АдресХранилища	 - Строка - Адрес временного хранилища, куда будут возвращены данные. Наличие параметра обусловлено использованием в подсистеме ДлительныеОперации
//
Процедура ПодготовитьПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData(Параметры, АдресХранилища) Экспорт
	ДанныеИнициализации = Обработки.НастройкаСтандартногоИнтерфейсаOData.ПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData();
	ПоместитьВоВременноеХранилище(ДанныеИнициализации, АдресХранилища);
КонецПроцедуры

// Возвращает роль, предназначенную для назначения пользователю информационной базы,
// логин и пароль которого будет использоваться при подключении к стандартному интерфейсу
// OData (в модели сервиса).
//
// Возвращаемое значение: ОбъектМетаданных (роль).
//
Функция РольДляСтандартногоИнтерфейсаOData() Экспорт
	
	Возврат Метаданные.Роли.УдаленныйДоступСтандартныйИнтерфейсOData;
	
КонецФункции

// Возвращает настройки авторизации для стандартного интерфейса OData (в модели сервиса).
//
// Возвращаемое значение: ФиксированнаяСтруктура, поля:
//                        * Используется - Булево - флаг включения авторизации для доступа
//                                         к стандартному интерфейсу OData,
//                        * Логин - Строка - логин пользователя для авторизации при доступе
//                                         к стандартному интерфейсу OData.
//
Функция НастройкиАвторизацииДляСтандартногоИнтерфейсаOData() Экспорт
	
	Результат = Новый Структура("Используется,Логин");
	Результат.Используется = Ложь;
	
	СвойстваПользователя = СвойстваПользователяСтандартногоИнтерфейсаOData();
	
	Если ЗначениеЗаполнено(СвойстваПользователя.Пользователь) Тогда
		
		Результат.Логин = СвойстваПользователя.Имя;
		Результат.Используется = СвойстваПользователя.Аутентификация;
		
	КонецЕсли;
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
	
КонецФункции

// Записывает настройки авторизации для стандартного интерфейса OData (в модели сервиса).
//
// Параметры:
//  НастройкиАвторизации - Структура, поля:
//                        * Используется - Булево - флаг включения авторизации для доступа
//                                         к стандартному интерфейсу OData,
//                        * Логин - Строка - логин пользователя для авторизации при доступе
//                                         к стандартному интерфейсу OData,
//                        * Пароль - Строка - пароль пользователя для авторизации при доступе
//                                         к стандартному интерфейсу OData. Значение передается
//                                         в составе структуры только в тех случаях, когда требуется
//                                         изменить пароль.
//
Процедура ЗаписатьНастройкиАвторизацииДляСтандартногоИнтерфейсаOData(Знач НастройкиАвторизации) Экспорт
	
	СвойстваПользователя = СвойстваПользователяСтандартногоИнтерфейсаOData();
	
	Если НастройкиАвторизации.Используется Тогда
		
		// Требуется создать или обновить пользователя ИБ
		
		ПроверитьВозможностьСозданияПользователяДляВызововСтандартногоИнтерфейсаOData();
		
		ОписаниеПользователяИБ = Новый Структура();
		ОписаниеПользователяИБ.Вставить("Действие", "Записать");
		ОписаниеПользователяИБ.Вставить("Имя", НастройкиАвторизации.Логин);
		ОписаниеПользователяИБ.Вставить("АутентификацияСтандартная", Истина);
		ОписаниеПользователяИБ.Вставить("АутентификацияОС", Ложь);
		ОписаниеПользователяИБ.Вставить("АутентификацияOpenID", Ложь);
		ОписаниеПользователяИБ.Вставить("ПоказыватьВСпискеВыбора", Ложь);
		Если НастройкиАвторизации.Свойство("Пароль") Тогда
			ОписаниеПользователяИБ.Вставить("Пароль", НастройкиАвторизации.Пароль);
		КонецЕсли;
		ОписаниеПользователяИБ.Вставить("ЗапрещеноИзменятьПароль", Истина);
		ОписаниеПользователяИБ.Вставить("Роли",
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
			РольДляСтандартногоИнтерфейсаOData().Имя));
		
		Если ЗначениеЗаполнено(СвойстваПользователя.Пользователь) Тогда
			ПользовательСтандартногоИнтерфейсаOData = СвойстваПользователя.Пользователь.ПолучитьОбъект();
		Иначе
			ПользовательСтандартногоИнтерфейсаOData = Справочники.Пользователи.СоздатьЭлемент();
		КонецЕсли;
		
		ПользовательСтандартногоИнтерфейсаOData.Наименование = НСтр("ru = 'Автоматический REST-сервис'");
		ПользовательСтандартногоИнтерфейсаOData.Служебный = Истина;
		ПользовательСтандартногоИнтерфейсаOData.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
		
		НачатьТранзакцию();
		
		Попытка
			
			ПользовательСтандартногоИнтерфейсаOData.Записать();
			
			Константы.ПользовательСтандартногоИнтерфейсаOData.Установить(
				ПользовательСтандартногоИнтерфейсаOData.Ссылка);
			
			ОписаниеПользователяИБ.Удалить("Пароль");
			
			СокращенноеОписание = Новый Структура;
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СокращенноеОписание, ОписаниеПользователяИБ);
			СокращенноеОписание.Удалить("ПользовательИБ");
			
			Комментарий = СтрШаблон(
				НСтр("ru = 'Выполнена запись пользователя для стандартного интерфейса OData.
                      |
                      |Описание пользователя ИБ:
                      |-------------------------------------------
                      |%1
                      |-------------------------------------------
                      |
                      |Результат:
                      |-------------------------------------------
                      |%2
                      |-------------------------------------------'"),
				ОбщегоНазначения.ЗначениеВСтрокуXML(СокращенноеОписание),
				ПользовательСтандартногоИнтерфейсаOData.ДополнительныеСвойства.ОписаниеПользователяИБ.РезультатДействия
			);
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(НСтр("ru = 'ЗаписьПользователя'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Информация,
				Метаданные.Справочники.Пользователи,
				,
				Комментарий
			);
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОписаниеПользователяИБ.Удалить("Пароль");
			
			Комментарий = СтрШаблон(
				НСтр("ru = 'При записи пользователя для стандартного интерфейса OData произошла ошибка.
                      |
                      |Описание пользователя ИБ:
                      |-------------------------------------------
                      |%1
                      |-------------------------------------------
                      |
                      |Текст ошибки:
                      |-------------------------------------------
                      |%2
                      |-------------------------------------------'"),
				ОбщегоНазначения.ЗначениеВСтрокуXML(ОписаниеПользователяИБ),
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке())
			);
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(НСтр("ru = 'ЗаписьПользователя'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка())),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Пользователи,
				,
				Комментарий
			);
			
			ВызватьИсключение;
			
		КонецПопытки;
		
	Иначе
		
		Если ЗначениеЗаполнено(СвойстваПользователя.Пользователь) Тогда
			
			// Требуется заблокировать пользователя ИБ
			
			ОписаниеПользователяИБ = Новый Структура();
			ОписаниеПользователяИБ.Вставить("Действие", "Записать");
			
			ОписаниеПользователяИБ.Вставить("ВходВПрограммуРазрешен", Ложь);
			
			ПользовательСтандартногоИнтерфейсаOData = СвойстваПользователя.Пользователь.ПолучитьОбъект();
			ПользовательСтандартногоИнтерфейсаOData.ДополнительныеСвойства.Вставить("ОписаниеПользователяИБ", ОписаниеПользователяИБ);
			ПользовательСтандартногоИнтерфейсаOData.Служебный = Истина;
			ПользовательСтандартногоИнтерфейсаOData.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает модель данных для объектов, которые могут быть включены в состава стандартного
// интерфейса OData (в модели сервиса).
//
// Возвращаемое значение: ТаблицаЗначений, колонки:
//                         * ОбъектМетаданных - ОбъектМетаданных - объект метаданных, который может
//                                              включен в состав стандартного интерфейса OData,
//                         * Чтение - Булево -  через стандартный интерфейс OData может быть предоставлен
//                                              доступ к чтению объекта,
//                         * Запись - Булево -  через стандартный интерфейс OData может быть предоставлен
//                                              доступ к записи объекта,
//                         * Зависимости -      Массив(ОбъектМетаданных) - массив объектов метаданных, которые
//                                              необходимо включить в состав стандартного интерфейса OData при
//                                              включении текущего объекта.
//
Функция МодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData() Экспорт
	
	Исключаемые = Новый Соответствие();
	
	Для Каждого ИсключаемыйОбъект Из ОбъектыИсключаемыеИзСтандартногоИнтерфейсаOData() Цикл
		Исключаемые.Вставить(ИсключаемыйОбъект.ПолноеИмя(), Истина);
	КонецЦикла;
	
	Результат = Новый ТаблицаЗначений();
	
	Результат.Колонки.Добавить("ПолноеИмя", Новый ОписаниеТипов("Строка"));
	Результат.Колонки.Добавить("Чтение", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("Изменение", Новый ОписаниеТипов("Булево"));
	Результат.Колонки.Добавить("Зависимости", Новый ОписаниеТипов("Массив"));
	
	Модель = ОбщегоНазначенияБТСПовтИсп.ОписаниеМоделиДанныхКонфигурации();
	
	Для Каждого Элементы Из Модель Цикл
		
		Для Каждого КлючИЗначение Из Элементы.Значение Цикл
			
			ОписаниеОбъекта = КлючИЗначение.Значение;
			
			Если Исключаемые.Получить(ОписаниеОбъекта.ПолноеИмя) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ОписаниеОбъекта.РазделениеДанных.Свойство(РаботаВМоделиСервиса.РазделительОсновныхДанных()) Тогда
				
				ЗаполнитьМодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData(Результат, ОписаниеОбъекта.ПолноеИмя, Исключаемые);
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Возвращает эталонный состав роли для назначения пользователю информационной базы,
// логин и пароль которого будет использоваться при подключении к стандартному интерфейсу
// OData (в модели сервиса).
//
// Возвращаемое значение: Соответствие:
//                        * Ключ - ОбъектМетаданных - объект метаданных,
//                        * Значение - Массив(Строка) - массив названий прав доступа,
//                                     которые должны быть разрешены для данного объекта
//                                     метаданных в роли.
//
Функция ЭталонныйСоставРолиДляСтандартногоИнтерфейсаOData() Экспорт
	
	Результат = Новый Соответствие();
	
	ВидыПрав = ВидыПравДляСтандартногоИнтерфейсаOData(Метаданные, Ложь, Ложь);
	Если ВидыПрав.Количество() > 0 Тогда
		Результат.Вставить(Метаданные, ВидыПрав);
	КонецЕсли;
	
	Для Каждого ПараметрСеанса Из Метаданные.ПараметрыСеанса Цикл
		ВидыПрав = ВидыПравДляСтандартногоИнтерфейсаOData(ПараметрСеанса, Истина, Ложь);
		Если ВидыПрав.Количество() > 0 Тогда
			Результат.Вставить(ПараметрСеанса, ВидыПрав);
		КонецЕсли;
	КонецЦикла;
	
	Модель = МодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData();
	
	Для Каждого ЭлементМодели Из Модель Цикл
		
		ВидыПрав = ВидыПравДляСтандартногоИнтерфейсаOData(
			ЭлементМодели.ПолноеИмя,
			ЭлементМодели.Чтение,
			ЭлементМодели.Изменение);
		
		Если ВидыПрав.Количество() > 0 Тогда
			Результат.Вставить(ЭлементМодели.ПолноеИмя, ВидыПрав);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Проверяет состав роли, предназначенной для назначения пользователю информационной базы,
// логин и пароль которого будет использоваться при подключении к стандартному интерфейсу
// OData (в модели сервиса).
//
// При наличии ошибок в настройке состава роли - генерируется исключение.
//
Процедура ПроверитьСоставРолиOData() Экспорт
	
	Роль = РольДляСтандартногоИнтерфейсаOData();
	
	ИзбыточныеПрава = Новый Соответствие();
	НедостающиеПрава = Новый Соответствие();
	
	ЭталонныйСостав = ЭталонныйСоставРолиДляСтандартногоИнтерфейсаOData();
	
	ПроверитьСоставРолиODataПоОбъектуМетаданных(Метаданные, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ПараметрыСеанса, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.Константы, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.Справочники, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.Документы, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ЖурналыДокументов, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ПланыВидовХарактеристик, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ПланыСчетов, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ПланыВидовРасчета, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.ПланыОбмена, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.БизнесПроцессы, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.Задачи, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.Последовательности, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.РегистрыСведений, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.РегистрыНакопления, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.РегистрыБухгалтерии, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	ПроверитьСоставРолиODataПоКоллекцииМетаданных(Метаданные.РегистрыРасчета, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	Для Каждого РегистрРасчета Из Метаданные.РегистрыРасчета Цикл
		ПроверитьСоставРолиODataПоКоллекцииМетаданных(РегистрРасчета.Перерасчеты, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	КонецЦикла;
	
	Ошибки = Новый Массив();
	
	Если ИзбыточныеПрава.Количество() > 0 Тогда
		ТекстОшибки = Символы.НПП + НСтр("ru = 'Следующие права избыточно включены в состав роли:'") + Символы.ПС + Символы.ВК + 
			ПредставлениеИзбыточныхИлиНедостающихПрав(ИзбыточныеПрава, 2);
		Ошибки.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Если НедостающиеПрава.Количество() > 0 Тогда
		ТекстОшибки = Символы.НПП + НСтр("ru = 'Следующие права должны быть включены в состав роли:'") + Символы.ПС + Символы.ВК + 
			ПредставлениеИзбыточныхИлиНедостающихПрав(НедостающиеПрава, 2);
		Ошибки.Добавить(ТекстОшибки);
	КонецЕсли;
	
	Если Ошибки.Количество() > 0 Тогда
		
		ТекстИсключения = СтрШаблон(НСтр("ru = 'Обнаружены ошибки в составе прав роли %1:'"),
			РольДляСтандартногоИнтерфейсаOData().Имя);
		
		Для Каждого Ошибка Из Ошибки Цикл
			
			ТекстИсключения = ТекстИсключения + Символы.ПС + Символы.ВК + Символы.Таб + Ошибка;
			
		КонецЦикла;
		
		ВызватьИсключение ТекстИсключения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыНастройкиСоставаСтандартногоИнтерфейсаOData() Экспорт
	
	Объект = Создать();
	Возврат Объект.ИнициализироватьДанныеДляНастройкиСоставаСтандартногоИнтерфейсаOData();
	
КонецФункции

Процедура ПроверитьСоставРолиODataПоКоллекцииМетаданных(КоллекцияМетаданных, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава)
	
	Для Каждого ОбъектМетаданных Из КоллекцияМетаданных Цикл
		ПроверитьСоставРолиODataПоОбъектуМетаданных(ОбъектМетаданных, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава);
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьСоставРолиODataПоОбъектуМетаданных(ОбъектМетаданных, ЭталонныйСостав, ИзбыточныеПрава, НедостающиеПрава)
	
	ВидыПрав = ОбщегоНазначенияБТС.ДопустимыеПраваДляОбъектаМетаданных(ОбъектМетаданных);
	
	ЭталонныеПрава = ЭталонныйСостав.Получить(ОбъектМетаданных.ПолноеИмя());
	Если ЭталонныеПрава = Неопределено Тогда
		ЭталонныеПрава = Новый Массив();
	КонецЕсли;
	
	ПредоставленныеПрава = Новый Массив();
	Для Каждого ВидПрава Из ВидыПрав Цикл
		Если ПравоДоступа(ВидПрава.Имя, ОбъектМетаданных, РольДляСтандартногоИнтерфейсаOData()) Тогда
			ПредоставленныеПрава.Добавить(ВидПрава.Имя);
		КонецЕсли;
	КонецЦикла;
	
	// Все права, которые есть в эталонных, но отсутствуют в предоставленных - недостающие.
	НедостающиеПраваПоОбъекту = Новый Массив();
	Для Каждого ВидПрава Из ЭталонныеПрава Цикл
		Если ПредоставленныеПрава.Найти(ВидПрава) = Неопределено Тогда
			НедостающиеПраваПоОбъекту.Добавить(ВидПрава);
		КонецЕсли;
	КонецЦикла;
	Если НедостающиеПраваПоОбъекту.Количество() > 0 Тогда
		НедостающиеПрава.Вставить(ОбъектМетаданных, НедостающиеПраваПоОбъекту);
	КонецЕсли;
	
	// Все права, которые есть в предоставленных, но отсутствуют в эталонных - избыточные.
	ИзбыточныеПраваПоОбъекту = Новый Массив();
	Для Каждого ВидПрава Из ПредоставленныеПрава Цикл
		Если ЭталонныеПрава.Найти(ВидПрава) = Неопределено Тогда
			ИзбыточныеПраваПоОбъекту.Добавить(ВидПрава);
		КонецЕсли;
	КонецЦикла;
	Если ИзбыточныеПраваПоОбъекту.Количество() > 0 Тогда
		ИзбыточныеПрава.Вставить(ОбъектМетаданных, ИзбыточныеПраваПоОбъекту);
	КонецЕсли;
	
КонецПроцедуры

Функция ВидыПравДляСтандартногоИнтерфейсаOData(Знач ОбъектМетаданных, Знач РазрешатьЧтениеДанных, Знач РазрешатьИзменениеДанных)
	
	ВсеВидыПрав = ОбщегоНазначенияБТС.ДопустимыеПраваДляОбъектаМетаданных(ОбъектМетаданных);
	
	ОтборПрав = Новый Структура();
	ОтборПрав.Вставить("Интерактивное", Ложь);
	ОтборПрав.Вставить("АдминистрированиеИнформационнойБазы", Ложь);
	ОтборПрав.Вставить("АдминистрированиеОбластиДанных", Ложь);
	
	Если РазрешатьЧтениеДанных И Не РазрешатьИзменениеДанных Тогда
		ОтборПрав.Вставить("Чтение", РазрешатьЧтениеДанных);
	КонецЕсли;
	
	Если РазрешатьИзменениеДанных И Не РазрешатьЧтениеДанных Тогда
		ОтборПрав.Вставить("Изменение", РазрешатьИзменениеДанных);
	КонецЕсли;
	
	ТребуемыеВидыПрав = ВсеВидыПрав.Скопировать(ОтборПрав);
	
	Возврат ТребуемыеВидыПрав.ВыгрузитьКолонку("Имя");
	
КонецФункции

Процедура ЗаполнитьМодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData(Знач Результат, Знач ПолноеИмя, Знач Исключаемые)
	
	Если Не ЭтоДопустимыйОбъектМетаданныхOData(ПолноеИмя) Тогда
		Возврат;
	КонецЕсли;
	
	Строка = Результат.Найти(ПолноеИмя, "ПолноеИмя");
	Если Строка = Неопределено Тогда
		Строка = Результат.Добавить();
	КонецЕсли;
	
	Строка.ПолноеИмя = ПолноеИмя;
	Строка.Чтение = Истина;
	Если ОбщегоНазначенияБТС.ЭтоПеречисление(ПолноеИмя) Тогда
		Строка.Изменение = Ложь;
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоЖурналДокументов(ПолноеИмя) Тогда
		Строка.Изменение = Ложь;
	ИначеЕсли Не ОбщегоНазначенияБТС.ЭтоРазделенныйОбъектМетаданных(ПолноеИмя, РаботаВМоделиСервиса.РазделительОсновныхДанных()) Тогда
		Строка.Изменение = Ложь;
	Иначе
		Строка.Изменение = Истина;
	КонецЕсли;
	
	Зависимости = ОбщегоНазначенияБТС.ЗависимостиОбъектаМетаданных(ПолноеИмя);
	
	Для Каждого КлючИЗначение Из Зависимости Цикл
		
		ПолноеИмяЗависимости = КлючИЗначение.Ключ;
		
		Если ПолноеИмяЗависимости = ПолноеИмя Тогда
			Продолжить;
		КонецЕсли;
		
		Если Исключаемые.Получить(ПолноеИмяЗависимости) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Строка.Зависимости.Добавить(ПолноеИмяЗависимости);
		
		СтрокаЗависимости = Результат.Найти(ПолноеИмяЗависимости, "ПолноеИмя");
		Если СтрокаЗависимости = Неопределено Тогда
			ЗаполнитьМодельДанныхПредоставляемыхДляСтандартногоИнтерфейсаOData(Результат, ПолноеИмяЗависимости, Исключаемые);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЭтоДопустимыйОбъектМетаданныхOData(Знач ОбъектМетаданных)
	
	Если ОбщегоНазначенияБТС.ЭтоСправочник(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоДокумент(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоПланОбмена(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоПланСчетов(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоПланВидовРасчета(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоПланВидовХарактеристик(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрБухгалтерии(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрСведений(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрРасчета(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоРегистрНакопления(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоЖурналДокументов(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоПеречисление(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоЗадача(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоБизнесПроцесс(ОбъектМетаданных)
		Или ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

Функция ПредставлениеИзбыточныхИлиНедостающихПрав(Знач ОписанияПрав, Знач Отступ)
	
	Результат = "";
	
	Для Каждого КлючИЗначение Из ОписанияПрав Цикл
		
		ОбъектМетаданных = КлючИЗначение.Ключ;
		Права = КлючИЗначение.Значение;
		
		Строка = "";
		
		Для Шаг = 1 По Отступ Цикл
			Строка = Строка + Символы.НПП;
		КонецЦикла;
		
		Строка = Строка + ОбъектМетаданных.ПолноеИмя() + ": " + СтрСоединить(Права, ", ");
		
		Если Не ПустаяСтрока(Результат) Тогда
			Результат = Результат + Символы.ПС;
		КонецЕсли;
		
		Результат = Результат + Строка;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОбъектыИсключаемыеИзСтандартногоИнтерфейсаOData()
	
	Возврат ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	
КонецФункции

Функция СвойстваПользователяСтандартногоИнтерфейсаOData()
	
	Если Не ПравоДоступа("АдминистрированиеДанных", Метаданные) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа для настройки автоматического REST-сервиса'");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Результат = Новый Структура("Пользователь, Идентификатор, Имя, Аутентификация", Справочники.Пользователи.ПустаяСсылка(), Неопределено, "", Ложь);
	
	Пользователь = Константы.ПользовательСтандартногоИнтерфейсаOData.Получить();
	
	Если ЗначениеЗаполнено(Пользователь) Тогда
		
		Результат.Пользователь = Пользователь;
		
		Идентификатор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Пользователь, "ИдентификаторПользователяИБ");
		
		Если ЗначениеЗаполнено(Идентификатор) Тогда
			
			Результат.Идентификатор = Идентификатор;
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Идентификатор);
			
			Если ПользовательИБ <> Неопределено Тогда
				
				Результат.Имя = ПользовательИБ.Имя;
				Результат.Аутентификация = ПользовательИБ.АутентификацияСтандартная;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации(Знач Суффикс)
	
	Возврат НСтр("ru = 'НастройкаСтандартногоИнтерфейсаOData.'") + СокрЛП(Суффикс);
	
КонецФункции

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		
		Обработчик = Обработчики.Добавить();
		Обработчик.Версия = "*";
		Обработчик.НачальноеЗаполнение = Истина;
		Обработчик.Процедура = "Обработки.НастройкаСтандартногоИнтерфейсаOData.ПроверитьСоставРолиODataПриОбновлении";
		Обработчик.ОбщиеДанные = Истина;
		Обработчик.РежимВыполнения = "Оперативно";
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСоставРолиODataПриОбновлении() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ПроверитьСоставРолиOData();
	Иначе
		ВызватьИсключение НСтр("ru = 'Обработчик не должен использоваться при выключенном разделении по областям данных'");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьВозможностьСозданияПользователяДляВызововСтандартногоИнтерфейсаOData()
	
	УстановитьПривилегированныйРежим(Истина);
	КоличествоПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей().Количество();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если КоличествоПользователей = 0 Тогда
		
		ВызватьИсключение НСтр("ru = 'Нельзя создать отдельные логин и пароль для использования автоматического REST-сервиса, т.к. в программе отсутствуют другие пользователи.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
