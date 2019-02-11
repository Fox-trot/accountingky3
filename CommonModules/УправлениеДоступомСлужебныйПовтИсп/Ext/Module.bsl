﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. УправлениеДоступомСлужебный.СвойстваВидовДоступа.
Функция СвойстваВидовДоступа() Экспорт
	
	СвойстваВидовДоступа = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(
		"СтандартныеПодсистемы.УправлениеДоступом.СвойстваВидовДоступа");
	
	Если СвойстваВидовДоступа = Неопределено Тогда
		УправлениеДоступомСлужебный.ОбновитьОписаниеСвойствВидовДоступа();
	КонецЕсли;
	
	СвойстваВидовДоступа = СтандартныеПодсистемыСервер.ПараметрРаботыПрограммы(
		"СтандартныеПодсистемы.УправлениеДоступом.СвойстваВидовДоступа");
	
	Возврат СвойстваВидовДоступа;
	
КонецФункции

// См. РегистрыСведений.НастройкиПравОбъектов.ВозможныеПрава.
Функция ВозможныеПраваДляНастройкиПравОбъектов() Экспорт
	
	Возврат РегистрыСведений.НастройкиПравОбъектов.ВозможныеПраваДляНастройкиПравОбъектов();
	
КонецФункции

// См. Справочники.ПрофилиГруппДоступа.ПоставляемыеПрофили.
Функция ОписаниеПоставляемыхПрофилей() Экспорт
	
	Возврат Справочники.ПрофилиГруппДоступа.ОписаниеПоставляемыхПрофилей();
	
КонецФункции

// Возвращает таблицу значений, содержащую вид ограничений доступа по каждому праву
// объектов метаданных.
//  Если записи по праву нет, значит ограничений по праву нет.
//  Таблица содержит только виды доступа, заданные разработчиком,
// исходя из их применения в текстах ограничений.
//  Для получения всех видов доступа, включая используемые в наборах
// значений доступа может быть использовано
// текущее состояние регистра сведений НаборыЗначенийДоступа.
//
// Параметры:
//  ДляПроверки - Булево - вернуть текстовое описание ограничений прав, заполненное
//                         в переопределяемых модулях без проверки.
//
// Возвращаемое значение:
//  ТаблицаЗначений - если ДляПроверки = Ложь, состав колонок:
//    Таблица        - Строка - имя таблицы объекта метаданных, например, Справочник.Файлы.
//    Право          - Строка: "Чтение", "Изменение".
//    ВидДоступа     - Ссылка - пустая ссылка основного типа значений вида доступа,
//                              пустая ссылка владельца настроек прав.
//                   - Неопределено - для вида доступа Объект.
//    ТаблицаОбъекта - Ссылка - пустая ссылка объекта метаданных, через который ограничивается доступ,
//                     используя наборы значений доступа, например, Справочник.ПапкиФайлов.
//                   - Неопределено, если ВидДоступа <> Неопределено.
//
//  Строка - если ДляПроверки = Истина - ограничения прав, как они добавлены в переопределяемом модуле.
//
Функция ПостоянныеВидыОграниченийПравОбъектовМетаданных(ДляПроверки = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВидыДоступаПрав = Новый ТаблицаЗначений;
	ВидыДоступаПрав.Колонки.Добавить("Таблица",        Новый ОписаниеТипов("СправочникСсылка.ИдентификаторыОбъектовМетаданных"));
	ВидыДоступаПрав.Колонки.Добавить("Право",          Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20)));
	ВидыДоступаПрав.Колонки.Добавить("ВидДоступа",     ОписаниеТиповЗначенийДоступаИВладельцевНастроекПрав());
	ВидыДоступаПрав.Колонки.Добавить("ТаблицаОбъекта", Метаданные.РегистрыСведений.НаборыЗначенийДоступа.Измерения.Объект.Тип);
	
	ОграниченияПрав = "";
	
	Если ДляПроверки
	 Или Не УправлениеДоступомСлужебный.ОграничиватьДоступНаУровнеЗаписейУниверсально(Истина) Тогда
		
		ИнтеграцияПодсистемБСП.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(ОграниченияПрав);
		УправлениеДоступомПереопределяемый.ПриЗаполненииВидовОграниченийПравОбъектовМетаданных(ОграниченияПрав);
	Иначе
		ОграниченияПрав = УправлениеДоступомСлужебный.ВсеВидыОграниченийПравДляОтчетаПраваДоступа();
	КонецЕсли;
	
	Если ДляПроверки Тогда
		Возврат ОграниченияПрав;
	КонецЕсли;
	
	ВидыДоступаПоИменам = УправлениеДоступомСлужебныйПовтИсп.СвойстваВидовДоступа().ПоИменам;
	
	Для НомерСтроки = 1 По СтрЧислоСтрок(ОграниченияПрав) Цикл
		ТекущаяСтрока = СокрЛП(СтрПолучитьСтроку(ОграниченияПрав, НомерСтроки));
		Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
			ПояснениеОшибки = "";
			Если СтрЧислоВхождений(ТекущаяСтрока, ".") <> 3 И СтрЧислоВхождений(ТекущаяСтрока, ".") <> 5 Тогда
				ПояснениеОшибки = НСтр("ru = 'Строка должна быть в формате ""<Полное имя таблицы>.<Имя права>.<Имя вида доступа>[.Таблица объекта]"".'");
			Иначе
				ПозицияПрава = СтрНайти(ТекущаяСтрока, ".");
				ПозицияПрава = СтрНайти(Сред(ТекущаяСтрока, ПозицияПрава + 1), ".") + ПозицияПрава;
				Таблица = Лев(ТекущаяСтрока, ПозицияПрава - 1);
				ПозицияВидаДоступа = СтрНайти(Сред(ТекущаяСтрока, ПозицияПрава + 1), ".") + ПозицияПрава;
				Право = Сред(ТекущаяСтрока, ПозицияПрава + 1, ПозицияВидаДоступа - ПозицияПрава - 1);
				Если СтрЧислоВхождений(ТекущаяСтрока, ".") = 3 Тогда
					ВидДоступа = Сред(ТекущаяСтрока, ПозицияВидаДоступа + 1);
					ТаблицаОбъекта = "";
				Иначе
					ПозицияТаблицыОбъекта = СтрНайти(Сред(ТекущаяСтрока, ПозицияВидаДоступа + 1), ".") + ПозицияВидаДоступа;
					ВидДоступа = Сред(ТекущаяСтрока, ПозицияВидаДоступа + 1, ПозицияТаблицыОбъекта - ПозицияВидаДоступа - 1);
					ТаблицаОбъекта = Сред(ТекущаяСтрока, ПозицияТаблицыОбъекта + 1);
				КонецЕсли;
				
				Если Метаданные.НайтиПоПолномуИмени(Таблица) = Неопределено Тогда
					ПояснениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не найдена таблица ""%1"".'"), Таблица);
				
				ИначеЕсли Право <> "Чтение" И Право <> "Изменение" Тогда
					ПояснениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не найдено право ""%1"".'"), Право);
				
				ИначеЕсли ВРег(ВидДоступа) = ВРег("Объект") Тогда
					Если Метаданные.НайтиПоПолномуИмени(ТаблицаОбъекта) = Неопределено Тогда
						ПояснениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не найдена таблица объекта ""%1"".'"),
							ТаблицаОбъекта);
					Иначе
						ВидДоступаСсылка = Неопределено;
						ТаблицаОбъектаСсылка = УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(
							ТаблицаОбъекта);
					КонецЕсли;
					
				ИначеЕсли ВРег(ВидДоступа) = ВРег("НастройкиПрав") Тогда
					Если Метаданные.НайтиПоПолномуИмени(ТаблицаОбъекта) = Неопределено Тогда
						ПояснениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'Не найдена таблица владельца настроек прав ""%1"".'"),
							ТаблицаОбъекта);
					Иначе
						ВидДоступаСсылка = УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(
							ТаблицаОбъекта);
						ТаблицаОбъектаСсылка = Неопределено;
					КонецЕсли;
				
				ИначеЕсли ВидыДоступаПоИменам.Получить(ВидДоступа) = Неопределено Тогда
					ПояснениеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не найден вид доступа ""%1"".'"), ВидДоступа);
				Иначе
					ВидДоступаСсылка = ВидыДоступаПоИменам.Получить(ВидДоступа).Ссылка;
					ТаблицаОбъектаСсылка = Неопределено;
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ПояснениеОшибки) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Ошибка в строке описания вида ограничений права объекта метаданных:
						           |""%1"".'")
						+ Символы.ПС
						+ Символы.ПС,
						ТекущаяСтрока)
					+ ПояснениеОшибки;
			Иначе
				НовоеОписание = ВидыДоступаПрав.Добавить();
				НовоеОписание.Таблица        = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Таблица);
				НовоеОписание.Право          = Право;
				НовоеОписание.ВидДоступа     = ВидДоступаСсылка;
				НовоеОписание.ТаблицаОбъекта = ТаблицаОбъектаСсылка;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	// Добавление видов доступа объектов, которые определяются не только через наборы значений доступа.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗависимостиПравДоступа.ПодчиненнаяТаблица,
	|	ЗависимостиПравДоступа.ТипВедущейТаблицы
	|ИЗ
	|	РегистрСведений.ЗависимостиПравДоступа КАК ЗависимостиПравДоступа";
	ЗависимостиПрав = Запрос.Выполнить().Выгрузить();
	
	ПрекратитьПопытки = Ложь;
	Пока НЕ ПрекратитьПопытки Цикл
		ПрекратитьПопытки = Истина;
		Отбор = Новый Структура("ВидДоступа", Неопределено);
		ВидыДоступаОбъект = ВидыДоступаПрав.НайтиСтроки(Отбор);
		Для каждого Строка Из ВидыДоступаОбъект Цикл
			ИдентификаторТаблицы = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(
				ТипЗнч(Строка.ТаблицаОбъекта));
			
			Отбор = Новый Структура;
			Отбор.Вставить("ПодчиненнаяТаблица", Строка.Таблица);
			Отбор.Вставить("ТипВедущейТаблицы", Строка.ТаблицаОбъекта);
			Если ЗависимостиПрав.НайтиСтроки(Отбор).Количество() = 0 Тогда
				ВедущееПраво = Строка.Право;
			Иначе
				ВедущееПраво = "Чтение";
			КонецЕсли;
			Отбор = Новый Структура("Таблица, Право", ИдентификаторТаблицы, ВедущееПраво);
			ВидыДоступаВедущейТаблицы = ВидыДоступаПрав.НайтиСтроки(Отбор);
			Для каждого ОписаниеВидаДоступа Из ВидыДоступаВедущейТаблицы Цикл
				Если ОписаниеВидаДоступа.ВидДоступа = Неопределено Тогда
					// Вид доступа объект нельзя добавлять.
					Продолжить;
				КонецЕсли;
				Отбор = Новый Структура;
				Отбор.Вставить("Таблица",    Строка.Таблица);
				Отбор.Вставить("Право",      Строка.Право);
				Отбор.Вставить("ВидДоступа", ОписаниеВидаДоступа.ВидДоступа);
				Если ВидыДоступаПрав.НайтиСтроки(Отбор).Количество() = 0 Тогда
					ЗаполнитьЗначенияСвойств(ВидыДоступаПрав.Добавить(), Отбор);
					ПрекратитьПопытки = Ложь;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВидыДоступаПрав;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Функция ОписаниеКлючаЗаписи(ТипИлиПолноеИмя) Экспорт
	
	ОписаниеКлюча = Новый Структура("МассивПолей, СтрокаПолей", Новый Массив, "");
	
	Если ТипЗнч(ТипИлиПолноеИмя) = Тип("Тип") Тогда
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипИлиПолноеИмя);
	Иначе
		ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ТипИлиПолноеИмя);
	КонецЕсли;
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ОбъектМетаданных.ПолноеИмя());
	
	Для каждого Колонка Из Менеджер.СоздатьНаборЗаписей().Выгрузить().Колонки Цикл
		
		Если ОбъектМетаданных.Ресурсы.Найти(Колонка.Имя) = Неопределено
		   И ОбъектМетаданных.Реквизиты.Найти(Колонка.Имя) = Неопределено Тогда
			// Если поля нет в ресурсах и реквизитах, значит это поле - измерение.
			ОписаниеКлюча.МассивПолей.Добавить(Колонка.Имя);
			ОписаниеКлюча.СтрокаПолей = ОписаниеКлюча.СтрокаПолей + Колонка.Имя + ",";
		КонецЕсли;
	КонецЦикла;
	
	ОписаниеКлюча.СтрокаПолей = Лев(ОписаниеКлюча.СтрокаПолей, СтрДлина(ОписаниеКлюча.СтрокаПолей)-1);
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(ОписаниеКлюча);
	
КонецФункции

// Только для внутреннего использования.
Функция ТипыПоляТаблицы(ПолноеИмяПоля) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяПоля);
	
	МассивТипов = ОбъектМетаданных.Тип.Типы();
	
	ТипыПоля = Новый Соответствие;
	Для каждого Тип Из МассивТипов Цикл
		Если Тип = Тип("СправочникОбъект.ИдентификаторыОбъектовМетаданных") Тогда
			Продолжить;
		КонецЕсли;
		ТипыПоля.Вставить(Тип, Истина);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ТипыПоля);
	
КонецФункции

// Возвращает типы объектов и ссылок в указанных подписках на события.
// 
// Параметры:
//  ИменаПодписок - Строка - многострочная строка, содержащая
//                  строки начала имени подписки.
//
Функция ТипыОбъектовВПодпискахНаСобытия(ИменаПодписок, МассивПустыхСсылок = Ложь) Экспорт
	
	ТипыОбъектов = Новый Соответствие;
	
	Для каждого Подписка Из Метаданные.ПодпискиНаСобытия Цикл
		
		Для НомерСтроки = 1 По СтрЧислоСтрок(ИменаПодписок) Цикл
			
			НачалоИмени = СтрПолучитьСтроку(ИменаПодписок, НомерСтроки);
			ИмяПодписки = Подписка.Имя;
			
			Если ВРег(Лев(ИмяПодписки, СтрДлина(НачалоИмени))) = ВРег(НачалоИмени) Тогда
				
				Для каждого Тип Из Подписка.Источник.Типы() Цикл
					Если Тип = Тип("СправочникОбъект.ИдентификаторыОбъектовМетаданных") Тогда
						Продолжить;
					КонецЕсли;
					ТипыОбъектов.Вставить(Тип, Истина);
				КонецЦикла;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Не МассивПустыхСсылок Тогда
		Возврат Новый ФиксированноеСоответствие(ТипыОбъектов);
	КонецЕсли;
	
	Массив = Новый Массив;
	Для каждого КлючИЗначение Из ТипыОбъектов Цикл
		Массив.Добавить(УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(
			КлючИЗначение.Ключ));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

// Только для внутреннего использования.
Функция ТаблицаПустогоНабораЗаписей(ПолноеИмяРегистра) Экспорт
	
	Менеджер = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяРегистра);
	
	Возврат Новый ХранилищеЗначения(Менеджер.СоздатьНаборЗаписей().Выгрузить());
	
КонецФункции

// Только для внутреннего использования.
Функция ТаблицаПустыхСсылокУказанныхТипов(ПолноеИмяРеквизита) Экспорт
	
	ОписаниеТипов = Метаданные.НайтиПоПолномуИмени(ПолноеИмяРеквизита).Тип;
	
	ПустыеСсылки = Новый ТаблицаЗначений;
	ПустыеСсылки.Колонки.Добавить("ПустаяСсылка", ОписаниеТипов);
	
	Для каждого ТипЗначения Из ОписаниеТипов.Типы() Цикл
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
			ПустыеСсылки.Добавить().ПустаяСсылка = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя()).ПустаяСсылка();
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ХранилищеЗначения(ПустыеСсылки);
	
КонецФункции

// Только для внутреннего использования.
Функция СоответствиеПустыхСсылокУказаннымТипамСсылок(ПолноеИмяРеквизита) Экспорт
	
	ОписаниеТипов = Метаданные.НайтиПоПолномуИмени(ПолноеИмяРеквизита).Тип;
	
	ПустыеСсылки = Новый Соответствие;
	
	Для каждого ТипЗначения Из ОписаниеТипов.Типы() Цикл
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
			ПустыеСсылки.Вставить(ТипЗначения, ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя()).ПустаяСсылка() );
		КонецЕсли;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ПустыеСсылки);
	
КонецФункции

// Только для внутреннего использования.
Функция КодыТиповСсылок(ПолноеИмяРеквизита) Экспорт
	
	ОписаниеТипов = Метаданные.НайтиПоПолномуИмени(ПолноеИмяРеквизита).Тип;
	
	ЧисловыеКодыТипов = Новый Соответствие;
	ТекущийКод = 0;
	
	Для каждого ТипЗначения Из ОписаниеТипов.Типы() Цикл
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗначения) Тогда
			ЧисловыеКодыТипов.Вставить(ТипЗначения, ТекущийКод);
		КонецЕсли;
		ТекущийКод = ТекущийКод + 1;
	КонецЦикла;
	
	СтроковыеКодыТипов = Новый Соответствие;
	
	ДлинаСтроковогоКода = СтрДлина(Формат(ТекущийКод-1, "ЧН=0; ЧГ="));
	ФорматнаяСтрокаКода = "ЧЦ=" + Формат(ДлинаСтроковогоКода, "ЧН=0; ЧГ=") + "; ЧН=0; ЧВН=; ЧГ=";
	
	Для каждого КлючИЗначение Из ЧисловыеКодыТипов Цикл
		СтроковыеКодыТипов.Вставить(
			КлючИЗначение.Ключ,
			Формат(КлючИЗначение.Значение, ФорматнаяСтрокаКода));
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СтроковыеКодыТипов);
	
КонецФункции

// Только для внутреннего использования.
Функция КодыПеречислений() Экспорт
	
	КодыПеречислений = Новый Соответствие;
	
	Для каждого ТипЗначенияДоступа Из Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип.Типы() Цикл
		МетаданныеТипа = Метаданные.НайтиПоТипу(ТипЗначенияДоступа);
		Если МетаданныеТипа = Неопределено ИЛИ НЕ Метаданные.Перечисления.Содержит(МетаданныеТипа) Тогда
			Продолжить;
		КонецЕсли;
		Для каждого ЗначениеПеречисления Из МетаданныеТипа.ЗначенияПеречисления Цикл
			ИмяЗначения = ЗначениеПеречисления.Имя;
			КодыПеречислений.Вставить(Перечисления[МетаданныеТипа.Имя][ИмяЗначения], ИмяЗначения);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(КодыПеречислений);;
	
КонецФункции

// Только для внутреннего использования.
Функция ТипыГруппИЗначенийВидовДоступа() Экспорт
	
	СвойстваВидовДоступа = УправлениеДоступомСлужебныйПовтИсп.СвойстваВидовДоступа();
	
	ТипыГруппИЗначенийВидовДоступа = Новый ТаблицаЗначений;
	ТипыГруппИЗначенийВидовДоступа.Колонки.Добавить("ВидДоступа",        Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип);
	ТипыГруппИЗначенийВидовДоступа.Колонки.Добавить("ТипГруппИЗначений", Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип);
	
	Для каждого КлючИЗначение Из СвойстваВидовДоступа.ПоТипамГруппИЗначений Цикл
		Строка = ТипыГруппИЗначенийВидовДоступа.Добавить();
		Строка.ВидДоступа = КлючИЗначение.Значение.Ссылка;
		
		Типы = Новый Массив;
		Типы.Добавить(КлючИЗначение.Ключ);
		ОписаниеТипа = Новый ОписаниеТипов(Типы);
		
		Строка.ТипГруппИЗначений = ОписаниеТипа.ПривестиЗначение(Неопределено);
	КонецЦикла;
	
	Возврат ТипыГруппИЗначенийВидовДоступа;
	
КонецФункции

// Только для внутреннего использования.
Функция ОписаниеТиповЗначенийДоступаИВладельцевНастроекПрав() Экспорт
	
	Типы = Новый Массив;
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип.Типы() Цикл
		Типы.Добавить(Тип);
	КонецЦикла;
	
	Для Каждого Тип Из Метаданные.ОпределяемыеТипы.ВладелецНастроекПрав.Тип.Типы() Цикл
		Если Тип = Тип("Строка") Тогда
			Продолжить;
		КонецЕсли;
		Типы.Добавить(Тип);
	КонецЦикла;
	
	Возврат Новый ОписаниеТипов(Типы);
	
КонецФункции

// Только для внутреннего использования.
Функция ТипыЗначенийВидовДоступаИВладельцевНастроекПрав() Экспорт
	
	ТипыЗначенийВидовДоступаИВладельцевНастроекПрав = Новый ТаблицаЗначений;
	
	ТипыЗначенийВидовДоступаИВладельцевНастроекПрав.Колонки.Добавить("ВидДоступа",
		УправлениеДоступомСлужебныйПовтИсп.ОписаниеТиповЗначенийДоступаИВладельцевНастроекПрав());
	
	ТипыЗначенийВидовДоступаИВладельцевНастроекПрав.Колонки.Добавить("ТипЗначений",
		УправлениеДоступомСлужебныйПовтИсп.ОписаниеТиповЗначенийДоступаИВладельцевНастроекПрав());
	
	ТипыЗначенийВидовДоступа = ТипыЗначенийВидовДоступа();
	
	Для каждого Строка Из ТипыЗначенийВидовДоступа Цикл
		ЗаполнитьЗначенияСвойств(ТипыЗначенийВидовДоступаИВладельцевНастроекПрав.Добавить(), Строка);
	КонецЦикла;
	
	ВозможныеПрава = УправлениеДоступомСлужебныйПовтИсп.ВозможныеПраваДляНастройкиПравОбъектов();
	ВладельцыПрав = ВозможныеПрава.ПоТипамСсылок;
	
	Для каждого КлючИЗначение Из ВладельцыПрав Цикл
		
		Типы = Новый Массив;
		Типы.Добавить(КлючИЗначение.Ключ);
		ОписаниеТипа = Новый ОписаниеТипов(Типы);
		
		Строка = ТипыЗначенийВидовДоступаИВладельцевНастроекПрав.Добавить();
		Строка.ВидДоступа  = ОписаниеТипа.ПривестиЗначение(Неопределено);
		Строка.ТипЗначений = ОписаниеТипа.ПривестиЗначение(Неопределено);
	КонецЦикла;
	
	Возврат Новый ХранилищеЗначения(ТипыЗначенийВидовДоступаИВладельцевНастроекПрав);
	
КонецФункции

// Только для внутреннего использования.
Функция ВидыОграниченийПравОбъектовМетаданных() Экспорт
	
	Возврат Новый Структура("ДатаОбновления, Таблица", '00010101');
	
КонецФункции

#Область УниверсальноеОграничение

Функция ПустыеСсылкиТиповГруппИЗначений() Экспорт
	
	ТипыГруппИЗначенийВидовДоступа = УправлениеДоступомСлужебныйПовтИсп.ТипыГруппИЗначенийВидовДоступа();
	ПустыеСсылки = Новый Соответствие;
	
	Для Каждого Строка Из ТипыГруппИЗначенийВидовДоступа Цикл
		ПустыеСсылки.Вставить(ТипЗнч(Строка.ТипГруппИЗначений), Строка.ТипГруппИЗначений);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(ПустыеСсылки);
	
КонецФункции

Функция КэшПараметровОграничения(КлючДанныхПовторногоИспользования) Экспорт
	
	Хранилище = Новый Структура;
	Хранилище.Вставить("ВедущиеСпискиПроверенные", Новый Соответствие);
	Хранилище.Вставить("ОграниченияСписков",       Новый Соответствие);
	Хранилище.Вставить("ИдентификаторыТранзакции", Новый Соответствие);
	Хранилище.Вставить("ВсеВидыОграниченийПрав",   Неопределено);
	
	Возврат Хранилище;
	
КонецФункции

Функция КэшИзмененныхСписковПриОтключенномОбновленииКлючейДоступа() Экспорт
	
	Возврат ПараметрыСеанса.ОтключениеОбновленияКлючейДоступа.ИзмененныеСписки.Получить();
	
КонецФункции

Функция СпискиСОграничением() Экспорт
	
	Списки = Новый Соответствие;
	ИнтеграцияПодсистемБСП.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа(Списки);
	
	СвойстваСписков = Новый Соответствие;
	Для Каждого Список Из Списки Цикл
		ПолноеИмя = Список.Ключ.ПолноеИмя();
		СвойстваСписков.Вставить(ПолноеИмя, Список.Значение);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(СвойстваСписков);
	
КонецФункции

Функция РазрешенныйКлючДоступа() Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Справочники.КлючиДоступа.ПолучитьСсылку(
		Новый УникальныйИдентификатор("8bfeb2d1-08c3-11e8-bcf8-d017c2abb532"));
	
	СсылкаВБазеДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Ссылка");
	Если Не ЗначениеЗаполнено(СсылкаВБазеДанных) Тогда
		РазрешенныйКлюч = Справочники.КлючиДоступа.СоздатьЭлемент();
		РазрешенныйКлюч.УстановитьСсылкуНового(Ссылка);
		РазрешенныйКлюч.Наименование = НСтр("ru = 'Разрешенный ключ доступа'");
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлючиДоступа");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			СсылкаВБазеДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Ссылка");
			Если Не ЗначениеЗаполнено(СсылкаВБазеДанных) Тогда
				РазрешенныйКлюч.Записать();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
	Возврат Ссылка;
	
КонецФункции

Функция РазрешенныйПустойНаборГруппДоступа() Экспорт
	
	УстановитьОтключениеБезопасногоРежима(Истина);
	УстановитьПривилегированныйРежим(Истина);
	
	Ссылка = Справочники.НаборыГруппДоступа.ПолучитьСсылку(
		Новый УникальныйИдентификатор("b5bc5b29-a11d-11e8-8787-b06ebfbf08c7"));
	
	СсылкаВБазеДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Ссылка");
	Если Не ЗначениеЗаполнено(СсылкаВБазеДанных) Тогда
		РазрешенныйПустойНабор = Справочники.НаборыГруппДоступа.СоздатьЭлемент();
		РазрешенныйПустойНабор.УстановитьСсылкуНового(Ссылка);
		РазрешенныйПустойНабор.Наименование = НСтр("ru = 'Разрешенный пустой набор групп доступа'");
		РазрешенныйПустойНабор.ТипЭлементовНабора = Справочники.ГруппыДоступа.ПустаяСсылка();
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.НаборыГруппДоступа");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
		
		НачатьТранзакцию();
		Попытка
			Блокировка.Заблокировать();
			СсылкаВБазеДанных = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Ссылка");
			Если Не ЗначениеЗаполнено(СсылкаВБазеДанных) Тогда
				РазрешенныйПустойНабор.Записать();
			КонецЕсли;
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	УстановитьОтключениеБезопасногоРежима(Ложь);
	
	Возврат Ссылка;
	
КонецФункции

Функция РазмерностьКлючаДоступа() Экспорт
	
	МетаданныеКлюча = Метаданные.Справочники.КлючиДоступа;
	
	Если КоличествоПодобныхЭлементовВКоллекции(МетаданныеКлюча.Реквизиты, "Значение") <> 5 Тогда
		ВызватьИсключение
			НСтр("ru = 'В справочнике КлючиДоступа должно быть 5 реквизитов Значение* и не более.'");
	КонецЕсли;
	
	Если МетаданныеКлюча.ТабличныеЧасти.Найти("Шапка") = Неопределено
	 Или КоличествоПодобныхЭлементовВКоллекции(МетаданныеКлюча.ТабличныеЧасти.Шапка.Реквизиты, "Значение", 6) <> 5 Тогда
		ВызватьИсключение
			НСтр("ru = 'В справочнике КлючиДоступа должна быть табличная часть Шапка с 5 реквизитами Значение* и не более.'");
	КонецЕсли;
	
	КоличествоТабличныхЧастей = КоличествоПодобныхЭлементовВКоллекции(МетаданныеКлюча.ТабличныеЧасти, "ТабличнаяЧасть");
	Если КоличествоТабличныхЧастей < 1 Или КоличествоТабличныхЧастей > 12 Тогда
		ВызватьИсключение
			НСтр("ru = 'В справочнике КлючиДоступа должно быть от 1 до 12 табличных частей ТабличнаяЧасть*.'");
	КонецЕсли;
	
	КоличествоТабличныхЧастей = 0;
	КоличествоРеквизитовТабличнойЧасти = 0;
	Для Каждого ТабличнаяЧасть Из МетаданныеКлюча.ТабличныеЧасти Цикл
		Если Не СтрНачинаетсяС(ТабличнаяЧасть.Имя, "ТабличнаяЧасть") Тогда
			Продолжить;
		КонецЕсли;
		КоличествоТабличныхЧастей = КоличествоТабличныхЧастей + 1;
		Количество = КоличествоПодобныхЭлементовВКоллекции(ТабличнаяЧасть.Реквизиты, "Значение");
		Если Количество < 1 Или Количество > 15 Тогда
			КоличествоРеквизитовТабличнойЧасти = 0;
			Прервать;
		КонецЕсли;
		Если КоличествоРеквизитовТабличнойЧасти <> 0
		   И КоличествоРеквизитовТабличнойЧасти <> Количество Тогда
			
			КоличествоРеквизитовТабличнойЧасти = 0;
			Прервать;
		КонецЕсли;
		КоличествоРеквизитовТабличнойЧасти = Количество;
	КонецЦикла;
	
	Если КоличествоРеквизитовТабличнойЧасти = 0 Тогда
		ВызватьИсключение
			НСтр("ru = 'В справочнике КлючиДоступа в табличных частях ТабличнаяЧасть*
			           |допустимо только одинаковое количество реквизитов Значение* и не более 15.'");
	КонецЕсли;
	
	Размерность = Новый Структура;
	Размерность.Вставить("КоличествоТабличныхЧастей",          КоличествоТабличныхЧастей);
	Размерность.Вставить("КоличествоРеквизитовТабличнойЧасти", КоличествоРеквизитовТабличнойЧасти);
	
	Возврат Новый ФиксированнаяСтруктура(Размерность);
	
КонецФункции

Функция КоличествоОпорныхПолейРегистра(ИмяРегистра = "") Экспорт
	
	Если ИмяРегистра = "" Тогда
		МетаданныеРегистраКлючей = Метаданные.РегистрыСведений.КлючиДоступаКРегистрам;
	Иначе
		МетаданныеРегистраКлючей = Метаданные.РегистрыСведений[ИмяРегистра];
	КонецЕсли;
	
	ПоследнийНомерПоля = 0;
	Для Каждого Измерение Из МетаданныеРегистраКлючей.Измерения Цикл
		Если Измерение.Имя = "Регистр" Тогда
			Если ИмяРегистра = "" Тогда
				Продолжить;
			КонецЕсли;
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'В отдельном регистре сведений %1
				           |не должно быть измерения %2.'"), ИмяРегистра, "Регистр");
		КонецЕсли;
		Если Измерение.Имя = "ДляВнешнихПользователей" Тогда
			Продолжить;
		КонецЕсли;
		Если СтрДлина(Измерение.Имя) <> 5 Или Не СтрНачинаетсяС(Измерение.Имя, "Поле") Тогда
			Прервать;
		КонецЕсли;
		Если Прав(Измерение.Имя, 1) <> Строка(ПоследнийНомерПоля + 1) Тогда
			Прервать;
		КонецЕсли;
		ПоследнийНомерПоля = ПоследнийНомерПоля + 1;
	КонецЦикла;
	
	Возврат ПоследнийНомерПоля;
	
КонецФункции

Функция МаксимальноеКоличествоОпорныхПолейРегистра() Экспорт
	
	// При изменении нужно синхронно изменить шаблон ограничения доступа ДляРегистра.
	Возврат Число(5);
	
КонецФункции

Функция ПустыеЗначенияОпорныхПолей(Количество) Экспорт
	
	ПустыеЗначения = Новый Структура;
	Для Номер = 1 По Количество Цикл
		ПустыеЗначения.Вставить("Поле" + Номер, Перечисления.ДополнительныеЗначенияДоступа.Null);
	КонецЦикла;
	
	Возврат ПустыеЗначения;
	
КонецФункции

Функция СинтаксисЯзыка() Экспорт
	
	Возврат УправлениеДоступомСлужебный.СинтаксисЯзыка();
	
КонецФункции

Функция УзлыДляПроверкиДоступности(Список, ЭтоСписокИсключений) Экспорт
	
	Возврат УправлениеДоступомСлужебный.УзлыДляПроверкиДоступности(Список, ЭтоСписокИсключений);
	
КонецФункции

Функция РазделенныеДанныеНедоступны() Экспорт
	
	Возврат Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
КонецФункции

Функция ОписаниеПредопределенногоИдентификатораОбъектаМетаданных(ПолноеИмяОбъектаМетаданных) Экспорт
	
	Имена = УправлениеДоступомСлужебныйПовтИсп.ИменаПредопределенныхЭлементовСправочника(
		"ИдентификаторыОбъектовМетаданных");
	
	Имя = СтрЗаменить(ПолноеИмяОбъектаМетаданных, ".", "");
	
	Если Имена.Найти(Имя) <> Неопределено Тогда
		Возврат "ИдентификаторыОбъектовМетаданных." + Имя;
	КонецЕсли;
	
	Имена = УправлениеДоступомСлужебныйПовтИсп.ИменаПредопределенныхЭлементовСправочника(
		"ИдентификаторыОбъектовРасширений");
	
	Если Имена.Найти(Имя) <> Неопределено Тогда
		Возврат "ИдентификаторыОбъектовРасширений." + Имя;
	КонецЕсли;
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	Если ОбъектМетаданных = Неопределено Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось получить имя предопределенного идентификатора объекта метаданных
			           |так как не существует указанный объект метаданных:
			           |""%1"".'"),
			ПолноеИмяОбъектаМетаданных);
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ОбъектМетаданных.РасширениеКонфигурации() = Неопределено Тогда
		Возврат "ИдентификаторыОбъектовМетаданных." + Имя;
	КонецЕсли;
	
	Возврат "ИдентификаторыОбъектовРасширений." + Имя;
	
КонецФункции

Функция ИменаПредопределенныхЭлементовСправочника(ИмяСправочника) Экспорт
	
	Возврат Метаданные.Справочники[ИмяСправочника].ПолучитьИменаПредопределенных();
	
КонецФункции

Функция ДопустимыеТипыЗначенийКлючейДоступа() Экспорт
	
	РазмерностьКлюча = РазмерностьКлючаДоступа();
	РеквизитыСправочника      = Метаданные.Справочники.КлючиДоступа.Реквизиты;
	ТабличныеЧастиСправочника = Метаданные.Справочники.КлючиДоступа.ТабличныеЧасти;
	
	ДопустимыеТипы = РеквизитыСправочника.Значение1.Тип.Типы();
	Для НомерРеквизита = 2 По 5 Цикл
		УточнитьДопустимыеТипы(ДопустимыеТипы, РеквизитыСправочника["Значение" + НомерРеквизита]);
	КонецЦикла;
	Для НомерРеквизита = 6 По 10 Цикл
		УточнитьДопустимыеТипы(ДопустимыеТипы, ТабличныеЧастиСправочника.Шапка.Реквизиты["Значение" + НомерРеквизита]);
	КонецЦикла;
	Для НомерТабличнойЧасти = 1 По РазмерностьКлюча.КоличествоТабличныхЧастей Цикл
		ТабличнаяЧасть = ТабличныеЧастиСправочника["ТабличнаяЧасть" + НомерТабличнойЧасти];
		Для НомерРеквизита = 1 По РазмерностьКлюча.КоличествоРеквизитовТабличнойЧасти Цикл
			УточнитьДопустимыеТипы(ДопустимыеТипы, ТабличнаяЧасть.Реквизиты["Значение" + НомерРеквизита]);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Новый ОписаниеТипов(ДопустимыеТипы);
	
КонецФункции

Функция ПоследняяПроверкаВерсииРазрешенныхНаборов() Экспорт
	
	Возврат Новый Структура("Дата", '00010101');
	
КонецФункции

Функция ИменаРолейБазовыеПрава(ДляВнешнихПользователей) Экспорт
	
	ИменаРолей = Новый Массив;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		ИмяРоли = Роль.Имя;
		Если Не СтрНачинаетсяС(ВРег(ИмяРоли), ВРег("БазовыеПрава")) Тогда
			Продолжить;
		КонецЕсли;
		РольДляВнешнихПользователей = СтрНачинаетсяС(ВРег(ИмяРоли), ВРег("БазовыеПраваВнешнихПользователей"));
		Если РольДляВнешнихПользователей = ДляВнешнихПользователей Тогда 
			ИменаРолей.Добавить(ИмяРоли);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИменаРолей;
	
КонецФункции

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

Функция ТипыЗначенийВидовДоступа()
	
	СвойстваВидовДоступа = УправлениеДоступомСлужебныйПовтИсп.СвойстваВидовДоступа();
	
	ТипыЗначенийВидовДоступа = Новый ТаблицаЗначений;
	ТипыЗначенийВидовДоступа.Колонки.Добавить("ВидДоступа",  Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип);
	ТипыЗначенийВидовДоступа.Колонки.Добавить("ТипЗначений", Метаданные.ОпределяемыеТипы.ЗначениеДоступа.Тип);
	
	Для каждого КлючИЗначение Из СвойстваВидовДоступа.ПоТипамЗначений Цикл
		Строка = ТипыЗначенийВидовДоступа.Добавить();
		Строка.ВидДоступа = КлючИЗначение.Значение.Ссылка;
		
		Типы = Новый Массив;
		Типы.Добавить(КлючИЗначение.Ключ);
		ОписаниеТипа = Новый ОписаниеТипов(Типы);
		
		Строка.ТипЗначений = ОписаниеТипа.ПривестиЗначение(Неопределено);
	КонецЦикла;
	
	Возврат ТипыЗначенийВидовДоступа;
	
КонецФункции

#Область УниверсальноеОграничение

Функция КоличествоПодобныхЭлементовВКоллекции(Коллекция, НачалоИмени, НачальныйНомер = 1)
	
	КоличествоПодобных = 0;
	МаксимальныйНомер = 0;
	
	Для Каждого ЭлементКоллекции Из Коллекция Цикл
		Если Не СтрНачинаетсяС(ЭлементКоллекции.Имя, НачалоИмени) Тогда
			Продолжить;
		КонецЕсли;
		НомерЭлемента = Сред(ЭлементКоллекции.Имя, СтрДлина(НачалоИмени) + 1);
		Если СтрДлина(НомерЭлемента) < 1 Или СтрДлина(НомерЭлемента) > 2 Тогда
			КоличествоПодобных = 0;
			Прервать;
		КонецЕсли;
		Если Не ( Лев(НомерЭлемента, 1) >= "0" И Лев(НомерЭлемента, 1) <= "9" ) Тогда
			КоличествоПодобных = 0;
			Прервать;
		КонецЕсли;
		Если СтрДлина(НомерЭлемента) = 2
		   И Не ( Лев(НомерЭлемента, 2) >= "0" И Лев(НомерЭлемента, 2) <= "9" ) Тогда
			КоличествоПодобных = 0;
			Прервать;
		КонецЕсли;
		НомерЭлемента = Число(НомерЭлемента);
		Если НомерЭлемента < НачальныйНомер Тогда
			КоличествоПодобных = 0;
			Прервать;
		КонецЕсли;
		
		КоличествоПодобных = КоличествоПодобных + 1;
		МаксимальныйНомер = ?(МаксимальныйНомер > НомерЭлемента, МаксимальныйНомер, НомерЭлемента);
	КонецЦикла;
	
	Если МаксимальныйНомер - НачальныйНомер + 1 <> КоличествоПодобных Тогда
		КоличествоПодобных = 0;
	КонецЕсли;
	
	Возврат КоличествоПодобных;
	
КонецФункции

// Для функции ДопустимыеТипыЗначенийКлючейДоступа.
Процедура УточнитьДопустимыеТипы(ДопустимыеТипы, Реквизит);
	
	Индекс = ДопустимыеТипы.Количество() - 1;
	ОписаниеТипов = Реквизит.Тип;
	
	Пока Индекс >= 0 Цикл
		Если Не ОписаниеТипов.СодержитТип(ДопустимыеТипы[Индекс]) Тогда
			ДопустимыеТипы.Удалить(Индекс);
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
