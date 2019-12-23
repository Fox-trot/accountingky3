﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обмен сообщениями

// Возвращает состояние использования резервного копирования областей данных.
//
// Возвращаемое значение:
//   Булево - Истина, если резервное копирование используется.
//
Функция РезервноеКопированиеИспользуется() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ПоддержкаРезервногоКопирования.Получить();
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Активность пользователей в области данных.

// Устанавливает признак активности пользователя в текущей области.
// Признаком является значение совместно разделенной константы ДатаПоследнегоСтартаКлиентскогоСеанса.
//
Процедура УстановитьФлагАктивностиПользователяВОбласти() Экспорт
	
	Если НЕ РаботаВМоделиСервисаПовтИсп.ЭтоРазделеннаяКонфигурация()
		ИЛИ НЕ РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных()
		ИЛИ ТекущийРежимЗапуска() = Неопределено
		ИЛИ НЕ ПолучитьФункциональнуюОпцию("ПоддержкаРезервногоКопирования")
		ИЛИ РаботаВМоделиСервиса.ОбластьДанныхЗаблокирована(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса()) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	УстановитьФлагАктивностиВОбласти(); // Для обратной совместимости
	
	ДатаСтарта = ТекущаяУниверсальнаяДата();
	
	Если ДатаСтарта - Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Получить() < 3600 Тогда
		Возврат;
	КонецЕсли;
	
	Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Установить(ДатаСтарта);
	
КонецПроцедуры

// Возвращает соответствие русских названий полей программных системных настроек
// английским из XDTO-пакета ZoneBackupControl Менеджера сервиса.
// (тип: {http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl}Settings).
//
// Возвращаемое значение:
//   ФиксированноеСоответствие - соответствие русских имен полей настроек английским.
//
Функция СоответствиеРусскихИменПолейНастроекАнглийским() Экспорт
	
	Возврат РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	
КонецФункции

// Определяет, поддерживает ли приложение функциональность резервного копирования.
//
// Возвращаемое значение:
//  Булево - Истина, если приложение поддерживает функциональность резервного копирования.
//
Функция МенеджерСервисаПоддерживаетРезервноеКопирование() Экспорт
	
	Возврат РезервноеКопированиеОбластейДанныхПовтИсп.МенеджерСервисаПоддерживаетРезервноеКопирование();
	
КонецФункции

// Возвращает прокси web-сервиса контроля резервного копирования.
// 
// Возвращаемое значение: 
//   WSПрокси - прокси менеджера сервиса.
// 
Функция ПроксиКонтроляРезервногоКопирования() Экспорт
	
	Возврат РезервноеКопированиеОбластейДанныхПовтИсп.ПроксиКонтроляРезервногоКопирования();
	
КонецФункции

// Возвращает имя подсистемы, которое должно использоваться в именах
//  событий журнала регистрации.
//
// Возвращаемое значение:
//   Строка - имя подсистемы.
//
Функция ИмяПодсистемыДляСобытийЖурналаРегистрации() Экспорт
	
	Возврат Метаданные.Подсистемы.ТехнологияСервиса.Подсистемы.РезервноеКопированиеОбластейДанных.Имя;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Фоновые задания

// Возвращает наименование фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
//   Строка - наименование фонового задания.
//
Функция НаименованиеФоновогоРезервногоКопирования() Экспорт
	
	Возврат НСтр("ru = 'Резервное копирование области данных'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции


#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
// 
// Параметры:
// 	Параметры - См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.Параметры
// 
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Параметры.Вставить("РезервноеКопированиеОбластейДанных", ПолучитьФункциональнуюОпцию("ПоддержкаРезервногоКопирования"));
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.
// 
// Параметры:
// 	СоответствиеИменПсевдонимам - См. ОчередьЗаданийПереопределяемый.ПриОпределенииПсевдонимовОбработчиков.СоответствиеИменПсевдонимам
// 
Процедура ПриОпределенииПсевдонимовОбработчиков(СоответствиеИменПсевдонимам) Экспорт
	
	СоответствиеИменПсевдонимам.Вставить("РезервноеКопированиеОбластейДанных.ВыгрузитьОбластьВХранилищеМС");
	СоответствиеИменПсевдонимам.Вставить("РезервноеКопированиеОбластейДанных.СозданиеКопий");
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов.
// 
// Параметры:
// 	СтруктураПоддерживаемыхВерсий - См. ОбщегоНазначенияПереопределяемый.ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов.ПоддерживаемыеВерсии
// 
Процедура ПриОпределенииПоддерживаемыхВерсийПрограммныхИнтерфейсов(Знач СтруктураПоддерживаемыхВерсий) Экспорт
	
	МассивВерсий = Новый Массив;
	МассивВерсий.Добавить("1.0.1.1");
	МассивВерсий.Добавить("1.0.1.2");
	СтруктураПоддерживаемыхВерсий.Вставить("РезервноеКопированиеОбластейДанных", МассивВерсий);
	
КонецПроцедуры

// См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.
// 
// Параметры:
// 	Типы - См. ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки.Типы
// 
Процедура ПриЗаполненииТиповИсключаемыхИзВыгрузкиЗагрузки(Типы) Экспорт
	
	Типы.Добавить(Метаданные.Константы.ВыполнитьРезервноеКопированиеОбластиДанных);
	Типы.Добавить(Метаданные.Константы.ДатаПоследнегоСтартаКлиентскогоСеанса);
	
КонецПроцедуры

// См. РаботаВМоделиСервисаПереопределяемый.ПриЗаполненииТаблицыПараметровИБ.
// 
// Параметры:
// 	ТаблицаПараметров - См. РаботаВМоделиСервисаПереопределяемый.ПриЗаполненииТаблицыПараметровИБ.ТаблицаПараметров
// 
Процедура ПриЗаполненииТаблицыПараметровИБ(ТаблицаПараметров) Экспорт
	
	РаботаВМоделиСервиса.ДобавитьКонстантуВТаблицуПараметровИБ(ТаблицаПараметров, "ПоддержкаРезервногоКопирования");
	
КонецПроцедуры

// См. ОчередьЗаданийПереопределяемый.ПриОпределенииОбработчиковОшибок.
// 
// Параметры:
// 	ОбработчикиОшибок - См. ОчередьЗаданийПереопределяемый.ПриОпределенииОбработчиковОшибок.ОбработчикиОшибок
// 
Процедура ПриОпределенииОбработчиковОшибок(ОбработчикиОшибок) Экспорт
	
	ОбработчикиОшибок.Вставить(
		"РезервноеКопированиеОбластейДанных.СозданиеКопий",
		"РезервноеКопированиеОбластейДанных.ОшибкаСозданияКопии");
	
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.
// 
// Параметры:
// 	МассивОбработчиков - См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиПринимаемыхСообщений.МассивОбработчиков
// 
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУправлениеРезервнымКопированиемИнтерфейс);
	
КонецПроцедуры

// См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.
// 
// Параметры:
// 	МассивОбработчиков - См. ИнтерфейсыСообщенийВМоделиСервисаПереопределяемый.ЗаполнитьОбработчикиОтправляемыхСообщений.МассивОбработчиков
// 
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольРезервногоКопированияИнтерфейс);
	
КонецПроцедуры

// Возвращает имя метода фонового задания выгрузки области в файл.
//
// Возвращаемое значение:
//   Строка - имя метода.
//
Функция ИмяМетодаФоновогоРезервногоКопирования() Экспорт
	
	Возврат "РезервноеКопированиеОбластейДанных.ВыгрузитьОбластьВХранилищеМС";
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Активность пользователей в области данных.

// Устанавливает либо снимает признак активности пользователя в текущей области.
// Признаком является значение совместно разделенной константы ВыполнитьРезервноеКопированиеОбластиДанных.
// Устарело.
//
// Параметры:
// ОбластьДанных - Число; Неопределено - Значение разделителя. Неопределено означает значение разделителя текущей
//                 области данных.
// Состояние - Булево - Истина, если признак надо установить; Ложь, если снять.
//
Процедура УстановитьФлагАктивностиВОбласти(Знач ОбластьДанных = Неопределено, Знач Состояние = Истина)
	
	Если ОбластьДанных = Неопределено Тогда
		Если РаботаВМоделиСервиса.ДоступноИспользованиеРазделенныхДанных() Тогда
			ОбластьДанных = РаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		Иначе
			ВызватьИсключение НСтр("ru = 'При вызове процедуры УстановитьФлагАктивностиВОбласти из неразделенного сеанса параметр ОбластьДанных является обязательным.'");
		КонецЕсли;
	Иначе
		Если НЕ РаботаВМоделиСервиса.СеансЗапущенБезРазделителей()
				И ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
			
			ВызватьИсключение(НСтр("ru = 'Запрещено работать с данными области кроме текущей'"));
			
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Состояние Тогда
		МенеджерЗначения = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
		МенеджерЗначения.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
		МенеджерЗначения.Прочитать();
		Если МенеджерЗначения.Значение Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ФлагАктивности = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
	ФлагАктивности.ОбластьДанныхВспомогательныеДанные = ОбластьДанных;
	ФлагАктивности.Значение = Состояние;
	РаботаВМоделиСервиса.ЗаписатьВспомогательныеДанные(ФлагАктивности);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Выгрузка областей данных.

// Создает резервную копию области в соответствии с настройками резервного копирования
// области.
//
// Параметры:
//  ПараметрыСоздания - ФиксированнаяСтруктура - параметры создания резервной копии,
//   соответствуют настройкам резервного копирования.
//  СостояниеСоздания - ФиксированнаяСтруктура - состояние процесса создания
//   резервных копий в области.
//
Процедура СозданиеКопий(Знач ПараметрыСоздания, Знач СостояниеСоздания) Экспорт
	
	НачалоВыполнения = ТекущаяУниверсальнаяДата();
	
	УсловияСозданияКопий = Новый Массив;
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежедневная");
	Параметры.Вставить("Включены", "СоздаватьЕжедневные");
	Параметры.Вставить("Периодичность", "День");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжедневной");
	Параметры.Вставить("День", Неопределено);
	Параметры.Вставить("Месяц", Неопределено);
	УсловияСозданияКопий.Добавить(Параметры);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежемесячная");
	Параметры.Вставить("Включены", "СоздаватьЕжемесячные");
	Параметры.Вставить("Периодичность", "Месяц");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжемесячной");
	Параметры.Вставить("День", "ДеньСозданияЕжемесячных");
	Параметры.Вставить("Месяц", Неопределено);
	УсловияСозданияКопий.Добавить(Параметры);
	
	Параметры = Новый Структура;
	Параметры.Вставить("Тип", "Ежегодная");
	Параметры.Вставить("Включены", "СоздаватьЕжегодные");
	Параметры.Вставить("Периодичность", "Год");
	Параметры.Вставить("ДатаСоздания", "ДатаСозданияПоследнейЕжегодной");
	Параметры.Вставить("День", "ДеньСозданияЕжегодных");
	Параметры.Вставить("Месяц", "МесяцСозданияЕжегодных");
	УсловияСозданияКопий.Добавить(Параметры);
	
	ТребуетсяСоздание = Ложь;
	ТекущаяДата = ТекущаяУниверсальнаяДата();
	
	ПоследнийСеанс = Константы.ДатаПоследнегоСтартаКлиентскогоСеанса.Получить();
	
	СоздаватьБезусловно = НЕ ПараметрыСоздания.ТолькоПриАктивностиПользователей;
	
	ФлагиПериодичности = Новый Структура;
	Для каждого ПараметрыПериодичности Из УсловияСозданияКопий Цикл
		
		ФлагиПериодичности.Вставить(ПараметрыПериодичности.Тип, Ложь);
		
		Если НЕ ПараметрыСоздания[ПараметрыПериодичности.Включены] Тогда
			// Создание копий данной периодичности выключено в настройках.
			Продолжить;
		КонецЕсли;
		
		ДатаСозданияПредыдущей = СостояниеСоздания[ПараметрыПериодичности.ДатаСоздания];
		
		Если Год(ТекущаяДата) = Год(ДатаСозданияПредыдущей) Тогда
			Если ПараметрыПериодичности.Периодичность = "Год" Тогда
				// Год еще не сменился
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если Месяц(ТекущаяДата) = Месяц(ДатаСозданияПредыдущей) Тогда
			Если ПараметрыПериодичности.Периодичность = "Месяц" Тогда
				// Месяц еще не сменился
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Если День(ТекущаяДата) = День(ДатаСозданияПредыдущей) Тогда
			// День еще не сменился
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыПериодичности.День <> Неопределено
			И День(ТекущаяДата) < ПараметрыСоздания[ПараметрыПериодичности.День] Тогда
			
			// Нужный день еще не наступил.
			Продолжить;
		КонецЕсли;
		
		Если ПараметрыПериодичности.Месяц <> Неопределено
			И Месяц(ТекущаяДата) < ПараметрыСоздания[ПараметрыПериодичности.Месяц] Тогда
			
			// Нужный месяц еще не наступил.
			Продолжить;
		КонецЕсли;
		
		Если НЕ СоздаватьБезусловно
			И ЗначениеЗаполнено(ДатаСозданияПредыдущей)
			И ПоследнийСеанс < ДатаСозданияПредыдущей Тогда
			
			// Пользователи не заходили в область после создания резервной копии.
			Продолжить;
		КонецЕсли;
		
		ТребуетсяСоздание = Истина;
		ФлагиПериодичности.Вставить(ПараметрыПериодичности.Тип, Истина);
		
	КонецЦикла;
	
	Если НЕ ТребуетсяСоздание Тогда
		ЗаписьЖурналаРегистрации(
			СобытиеЖурналаРегистрации() + "." 
				+ НСтр("ru = 'Пропуск создания'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация);
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаОбластейДанных") Тогда
		
		РаботаВМоделиСервиса.ВызватьИсключениеОтсутствуетПодсистемаБТС("ТехнологияСервиса.ВыгрузкаЗагрузкаОбластейДанных");
		
	КонецЕсли;
	
	МодульВыгрузкаЗагрузкаОбластейДанных = ОбщегоНазначения.ОбщийМодуль("ВыгрузкаЗагрузкаОбластейДанных");
	
	ИмяАрхива = Неопределено;
	
	Попытка
	
		ИмяАрхива = МодульВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив();
		
		ДатаСозданияКопии = ТекущаяУниверсальнаяДата();
		
		ОписаниеАрхива = Новый Файл(ИмяАрхива);
		РазмерФайла = ОписаниеАрхива.Размер();
		
		ИДФайла = ПоместитьФайлВХранилищеМенеджераСервиса(ОписаниеАрхива);
		
		Попытка
			УдалитьФайлы(ИмяАрхива);
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных.Не удалось удалить временный файл'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		ИдКопии = Новый УникальныйИдентификатор;
		
		ПараметрыСообщения = Новый Структура;
		ПараметрыСообщения.Вставить("ОбластьДанных", РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
		ПараметрыСообщения.Вставить("ИДКопии", ИдКопии);
		ПараметрыСообщения.Вставить("ИДФайла", ИДФайла);
		ПараметрыСообщения.Вставить("ДатаСоздания", ДатаСозданияКопии);
		Для каждого КлючИЗначение Из ФлагиПериодичности Цикл
			ПараметрыСообщения.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		
		ОтправитьСообщениеРезервнаяКопияОбластиСоздана(ПараметрыСообщения);
		
		// Обновление состояния в параметрах.
		ОтборЗаданий = Новый Структура;
		ОтборЗаданий.Вставить("ИмяМетода", "РезервноеКопированиеОбластейДанных.СозданиеКопий");
		ОтборЗаданий.Вставить("Ключ", "1");
		Задания = ОчередьЗаданий.ПолучитьЗадания(ОтборЗаданий);
		Если Задания.Количество() > 0 Тогда
			Задание = Задания.Получить(0).Идентификатор;
			
			ПараметрыМетода = Новый Массив;
			ПараметрыМетода.Добавить(ПараметрыСоздания);
			
			ОбновленноеСостояние = Новый Структура;
			Для каждого ПараметрыПериодичности Из УсловияСозданияКопий Цикл
				Если ФлагиПериодичности[ПараметрыПериодичности.Тип] Тогда
					ДатаСостояния = ДатаСозданияКопии;
				Иначе
					ДатаСостояния = СостояниеСоздания[ПараметрыПериодичности.ДатаСоздания];
				КонецЕсли;
				
				ОбновленноеСостояние.Вставить(ПараметрыПериодичности.ДатаСоздания, ДатаСостояния);
			КонецЦикла;
			
			ПараметрыМетода.Добавить(Новый ФиксированнаяСтруктура(ОбновленноеСостояние));
			
			ПараметрыЗадания = Новый Структура;
			ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
			ОчередьЗаданий.ИзменитьЗадание(Задание, ПараметрыЗадания);
		КонецЕсли;
		
		ПараметрыСобытия = Новый Структура;
		Для каждого КлючИЗначение Из ФлагиПериодичности Цикл
			ПараметрыСобытия.Вставить(КлючИЗначение.Ключ, КлючИЗначение.Значение);
		КонецЦикла;
		ПараметрыСобытия.Вставить("ИдКопии", ИдКопии);
		ПараметрыСобытия.Вставить("ИдФайла", ИдФайла);
		ПараметрыСобытия.Вставить("Размер", РазмерФайла);
		ПараметрыСобытия.Вставить("Длительность", ТекущаяУниверсальнаяДата() - НачалоВыполнения);
		
		ЗаписатьСобытиеВЖурнал(
			НСтр("ru = 'Создание'", ОбщегоНазначения.КодОсновногоЯзыка()),
			ПараметрыСобытия);
			
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Попытка
			Если ИмяАрхива <> Неопределено Тогда
				УдалитьФайлы(ИмяАрхива);
			КонецЕсли;
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных.Не удалось удалить временный файл'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
			
	КонецПопытки;
	
КонецПроцедуры

// При исчерпании количества попыток создания резервной копии, записывает в журнал
// регистрации сообщение о том, что копия не была создана. 
// Cм. ОчередьЗаданийПереопределяемый.ПриОпределенииОбработчиковОшибок.
//
// Параметры:
//  ПараметрыЗадания - см. ОчередьЗадаСтруктура - свойства структуры.
//   
Процедура ОшибкаСозданияКопии(Знач ПараметрыЗадания, Знач ИнформацияОбОшибке) Экспорт
	
	Если ПараметрыЗадания.НомерПопытки < ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении Тогда
		ШаблонКомментария = НСтр("ru = 'При создании резервной копии области %1 произошла ошибка.
			|Номер попытки: %2
			|По причине:
			|%3'");
		Уровень = УровеньЖурналаРегистрации.Предупреждение;
		Событие = НСтр("ru = 'Ошибка итерации создания'", ОбщегоНазначения.КодОсновногоЯзыка());
	Иначе
		ШаблонКомментария = НСтр("ru = 'При создании резервной копии области %1 произошла невосстановимая ошибка.
			|Номер попытки: %2
			|По причине:
			|%3'");
		Уровень = УровеньЖурналаРегистрации.Ошибка;
		Событие = НСтр("ru = 'Ошибка создания'", ОбщегоНазначения.КодОсновногоЯзыка());
	КонецЕсли;
	
	ТекстКомментария = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ШаблонКомментария,
		Формат(РаботаВМоделиСервиса.ЗначениеРазделителяСеанса(), "ЧН=0; ЧГ="),
		ПараметрыЗадания.НомерПопытки,
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
		
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации() + "." + Событие,
		Уровень,
		,
		,
		ТекстКомментария);
	
КонецПроцедуры

// Планирует создание резервной копии области данных.
//
// Параметры:
//  ПараметрыВыгрузки - Структура - состав ключей см. СоздатьПустыеПараметрыВыгрузки().
//
Процедура ЗапланироватьАрхивациюВОчереди(Знач ПараметрыВыгрузки) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru = 'Не достаточно прав для выполнения операции'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(ПараметрыВыгрузки);
	ПараметрыМетода.Добавить(Неопределено);
	
	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетодаФоновогоРезервногоКопирования());
	ПараметрыЗадания.Вставить("Ключ", "" + ПараметрыВыгрузки.ИДКопии);
	ПараметрыЗадания.Вставить("ОбластьДанных", ПараметрыВыгрузки.ОбластьДанных);
	
	// Поиск активных заданий с тем же ключом.
	АктивныеЗадания = ОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
	
	ПараметрыЗадания.Вставить("КоличествоПовторовПриАварийномЗавершении", 3);
	
	Если АктивныеЗадания.Количество() = 0 Тогда
		
		// Планируем выполнение нового.
		
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ПараметрыВыгрузки.МоментЗапуска);
		
		ОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
	Иначе
		Если АктивныеЗадания.Получить(0).СостояниеЗадания <> Перечисления.СостоянияЗаданий.Запланировано Тогда
			// Задание уже выполнилось или выполняется.
			Возврат;
		КонецЕсли;
		
		ПараметрыЗадания.Удалить("ОбластьДанных");
		
		ПараметрыЗадания.Вставить("Использование", Истина);
		ПараметрыЗадания.Вставить("Параметры", ПараметрыМетода);
		ПараметрыЗадания.Вставить("ЗапланированныйМоментЗапуска", ПараметрыВыгрузки.МоментЗапуска);
		
		ОчередьЗаданий.ИзменитьЗадание(АктивныеЗадания.Получить(0).Идентификатор, ПараметрыЗадания);
	КонецЕсли;
	
КонецПроцедуры

// Создает файл выгрузки заданной области и помещает его в хранилище Менеджера сервиса.
//
// Параметры:
// Параметры - Структура:
// 	- ОбластьДанных - Число.
//	- ИДКопии - УникальныйИдентификатор; Неопределено.
//  - МоментЗапуска - Дата - момент запуска архивирования области.
//	- Принудительно - Булево - Флаг из МС: необходимость создавать копию вне зависимости от активности пользователей.
//	- ПоТребованию - Булево - флаг интерактивного запуска архивирования. Если из МС - всегда Ложь.
//	- ИДФайла - УникальныйИдентификатор - ИД файла выгрузки в хранилище МС.
//	- НомерПопытки - Число - Счетчик попыток. Начальное значение: 1.
//
Процедура ВыгрузитьОбластьВХранилищеМС(Знач Параметры, АдресРезультата = Неопределено) Экспорт
	
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru = 'Нарушение прав доступа'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если Не ТребуетсяВыгрузка(Параметры) Тогда
		ОтправитьСообщениеАрхивацияОбластиПропущена(Параметры);
		Возврат;
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса.ВыгрузкаЗагрузкаОбластейДанных") Тогда
		
		РаботаВМоделиСервиса.ВызватьИсключениеОтсутствуетПодсистемаБТС("ТехнологияСервиса.ВыгрузкаЗагрузкаОбластейДанных");
		
	КонецЕсли;
	
	МодульВыгрузкаЗагрузкаОбластейДанных = ОбщегоНазначения.ОбщийМодуль("ВыгрузкаЗагрузкаОбластейДанных");
	
	ИмяАрхива = Неопределено;
	
	Попытка
		УстановитьМонопольныйРежим(Истина);
		
		ЕстьИзмененияВСтруктуреДанных = Ложь;		
		Для Каждого Расширение Из РасширенияКонфигурации.Получить() Цикл
			
			Если Расширение.ИзменяетСтруктуруДанных() Тогда
				ЕстьИзмененияВСтруктуреДанных = Истина;
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьИзмененияВСтруктуреДанных Тогда
			
			АдресДанных = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор);
			МассивПараметров = Новый Массив;
			МассивПараметров.Добавить(АдресДанных);
			
			ИмяМетода = "ВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив";
			НаименованиеЗадания = НСтр("ru = 'Выгрузка области с расширениями'");
			
			ФоновоеЗадание = РасширенияКонфигурации.ВыполнитьФоновоеЗаданиеСРасширениямиБазыДанных(ИмяМетода, МассивПараметров
				,Новый УникальныйИдентификатор
				,НаименованиеЗадания);
			ФоновоеЗадание.ОжидатьЗавершенияВыполнения();
			
			ИмяАрхива = ПолучитьИзВременногоХранилища(АдресДанных);
			
		Иначе
			ИмяАрхива = МодульВыгрузкаЗагрузкаОбластейДанных.ВыгрузитьТекущуюОбластьДанныхВАрхив(АдресДанных);			
		КонецЕсли;
		
		ИДФайла = ПоместитьФайлВХранилищеМенеджераСервиса(Новый Файл(ИмяАрхива));
		Попытка
			УдалитьФайлы(ИмяАрхива);
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных.Не удалось удалить временный файл'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		
		НачатьТранзакцию();
		
		Попытка
			
			Параметры.Вставить("ИДФайла", ИДФайла);
			Параметры.Вставить("ДатаСоздания", ТекущаяУниверсальнаяДата());
			ОтправитьСообщениеРезервнаяКопияОбластиСоздана(Параметры);
			Если ЗначениеЗаполнено(АдресРезультата) Тогда
				ПоместитьВоВременноеХранилище(ИДФайла, АдресРезультата);
			КонецЕсли;
			УстановитьФлагАктивностиВОбласти(Параметры.ОбластьДанных, Ложь);
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ВызватьИсключение;
			
		КонецПопытки;
		
	Исключение
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных'", ОбщегоНазначения.КодОсновногоЯзыка()), 
			УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Попытка
			Если ИмяАрхива <> Неопределено Тогда
				УдалитьФайлы(ИмяАрхива);
			КонецЕсли;
		Исключение
			// При невозможности удаления файла выполнение не должно прерываться.
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Создание резервной копии области данных.Не удалось удалить временный файл'", ОбщегоНазначения.КодОсновногоЯзыка()), 
				УровеньЖурналаРегистрации.Ошибка, , , ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		КонецПопытки;
		Если Параметры.ПоТребованию Тогда
			ВызватьИсключение;
		Иначе	
			Если Параметры.НомерПопытки > 3 Тогда
				ОтправитьСообщениеОшибкаАрхивацииОбласти(Параметры);
				ВызватьИсключение;
			Иначе	
				// Отмена задания.
				ОтменитьСозданиеРезервнойКопииОбласти(Параметры);
				
				// Перепланировать: текущее время области + 10 минут.
				Параметры.НомерПопытки = Параметры.НомерПопытки + 1;
				МоментПовторногоЗапуска = ТекущаяДатаОбласти(Параметры.ОбластьДанных); // Сейчас в области.
				МоментПовторногоЗапуска = МоментПовторногоЗапуска + 10 * 60; // На 10 минут позже.
				Параметры.Вставить("МоментЗапуска", МоментПовторногоЗапуска);
				ЗапланироватьАрхивациюВОчереди(Параметры);
			КонецЕсли;
		КонецЕсли;
	КонецПопытки;
	
КонецПроцедуры

Функция ТекущаяДатаОбласти(Знач ОбластьДанных)
	
	ЧасовойПояс = РаботаВМоделиСервиса.ПолучитьЧасовойПоясОбластиДанных(ОбластьДанных);
	Возврат МестноеВремя(ТекущаяУниверсальнаяДата(), ЧасовойПояс);
	
КонецФункции

Функция ТребуетсяВыгрузка(Знач ПараметрыВыгрузки)
	
	Если НЕ РаботаВМоделиСервиса.СеансЗапущенБезРазделителей()
		И ПараметрыВыгрузки.ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
		
		ВызватьИсключение(НСтр("ru = 'Запрещено работать с данными области кроме текущей'"));
	КонецЕсли;
	
	Результат = ПараметрыВыгрузки.Принудительно;
	
	Если Не Результат Тогда
		
		Менеджер = Константы.ВыполнитьРезервноеКопированиеОбластиДанных.СоздатьМенеджерЗначения();
		Менеджер.ОбластьДанныхВспомогательныеДанные = ПараметрыВыгрузки.ОбластьДанных;
		Менеджер.Прочитать();
		Результат = Менеджер.Значение;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Создает незаполненную структуру нужного формата.
//
// Возвращаемое значение:
// Структура:
// 	- ОбластьДанных - Число.
//	- ИДКопии - УникальныйИдентификатор; Неопределено.
//  - МоментЗапуска - Дата - момент запуска архивирования области.
//	- Принудительно - Булево - Флаг из МС: необходимость создавать копию вне зависимости от активности пользователей.
//	- ПоТребованию - Булево - флаг интерактивного запуска архивирования. Если из МС - всегда Ложь.
//	- ИДФайла - УникальныйИдентификатор - ИД файла выгрузки в хранилище МС.
//	- НомерПопытки - Число - Счетчик попыток. Начальное значение: 1.
//
Функция СоздатьПустыеПараметрыВыгрузки() Экспорт
	
	ПараметрыВыгрузки = Новый Структура;
	ПараметрыВыгрузки.Вставить("ОбластьДанных");
	ПараметрыВыгрузки.Вставить("ИДКопии");
	ПараметрыВыгрузки.Вставить("МоментЗапуска");
	ПараметрыВыгрузки.Вставить("Принудительно");
	ПараметрыВыгрузки.Вставить("ПоТребованию");
	ПараметрыВыгрузки.Вставить("ИДФайла");
	ПараметрыВыгрузки.Вставить("НомерПопытки", 1);
	Возврат ПараметрыВыгрузки;
	
КонецФункции

// Отменяет запланированное ранее создание резервной копии.
//
// ПараметрыОтмены - Структура
//  ОбластьДанных - Число - область данных создание резервной копии в которой требуется отменить.
//  ИДКопии - УникальныйИдентификатор - идентификатор копии, создание которой требуется отменить.
//
Процедура ОтменитьСозданиеРезервнойКопииОбласти(Знач ПараметрыОтмены) Экспорт
	
	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ВызватьИсключение(НСтр("ru = 'Не достаточно прав для выполнения операции'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяМетода = ИмяМетодаФоновогоРезервногоКопирования();
	
	Отбор = Новый Структура("ИмяМетода, Ключ, ОбластьДанных", 
		ИмяМетода, "" + ПараметрыОтмены.ИДКопии, ПараметрыОтмены.ОбластьДанных);
	Задания = ОчередьЗаданий.ПолучитьЗадания(Отбор);
	
	Для Каждого Задание Из Задания Цикл
		ОчередьЗаданий.УдалитьЗадание(Задание.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

// Сообщить об успешной архивации текущей области.
//
Процедура ОтправитьСообщениеРезервнаяКопияОбластиСоздана(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеРезервнаяКопияОбластиСоздана());
		
		Тело = Сообщение.Body;
		
		Тело.Zone = ПараметрыСообщения.ОбластьДанных;
		Тело.BackupId = ПараметрыСообщения.ИДКопии;
		Тело.FileId = ПараметрыСообщения.ИДФайла;
		Тело.Date = ПараметрыСообщения.ДатаСоздания;
		Если ПараметрыСообщения.Свойство("Ежедневная") Тогда
			Тело.Daily = ПараметрыСообщения.Ежедневная;
			Тело.Monthly = ПараметрыСообщения.Ежемесячная;
			Тело.Yearly = ПараметрыСообщения.Ежегодная;
		Иначе
			Тело.Daily = Ложь;
			Тело.Monthly = Ложь;
			Тело.Yearly = Ложь;
		КонецЕсли;
		Тело.ConfigurationVersion = Метаданные.Версия;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервиса.КонечнаяТочкаМенеджераСервиса());
			
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Планировать архивацию области в прикладной базе.
//
Процедура ОтправитьСообщениеОшибкаАрхивацииОбласти(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеОшибкаАрхивацииОбласти());
		
		Сообщение.Body.Zone = ПараметрыСообщения.ОбластьДанных;
		Сообщение.Body.BackupId = ПараметрыСообщения.ИДКопии;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервиса.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

// Планировать архивацию области в прикладной базе.
//
Процедура ОтправитьСообщениеАрхивацияОбластиПропущена(Знач ПараметрыСообщения)
	
	НачатьТранзакцию();
	Попытка
		
		Сообщение = СообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияКонтрольРезервногоКопированияИнтерфейс.СообщениеАрхивацияОбластиПропущена());
		
		Сообщение.Body.Zone = ПараметрыСообщения.ОбластьДанных;
		Сообщение.Body.BackupId = ПараметрыСообщения.ИДКопии;
		
		СообщенияВМоделиСервиса.ОтправитьСообщение(
			Сообщение,
			РаботаВМоделиСервиса.КонечнаяТочкаМенеджераСервиса());
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ВызватьИсключение;
		
	КонецПопытки;
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Резервное копирование приложений'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Процедура ЗаписатьСобытиеВЖурнал(Знач Событие, Знач Параметры)
	
	ЗаписьЖурналаРегистрации(
		СобытиеЖурналаРегистрации() + "." + Событие,
		УровеньЖурналаРегистрации.Информация,
		,
		,
		ОбщегоНазначения.ЗначениеВСтрокуXML(Параметры));
	
КонецПроцедуры

Функция ПоместитьФайлВХранилищеМенеджераСервиса(Файл)
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяФайла", Файл.Имя);
	ДополнительныеПараметры.Вставить("РазмерФайла", Файл.Размер());
	ДополнительныеПараметры.Вставить("ТипФайла", "РезервнаяКопияОбластиДанных");
	ДополнительныеПараметры.Вставить("ОбластьДанных", РаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
	ДополнительныеПараметры.Вставить("КлючОбластиДанных", Константы.КлючОбластиДанных.Получить());
	ДополнительныеПараметры.Вставить("ПоддержкаS3", Истина);
	
	Возврат РаботаВМоделиСервиса.ПоместитьФайлВХранилищеМенеджераСервиса(Файл, , ДополнительныеПараметры);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с настройками резервного копирования.

// Возвращает структуру настроек резервного копирования области данных.
//
// Параметры:
// ОбластьДанных - Число; Неопределено - Если Неопределено, возвращаются системные настройки.
//
// Возвращаемое значение:
// Структура - структура настроек. 
//	См. РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским().
//
Функция ПолучитьНастройкиРезервногоКопированияОбласти(Знач ОбластьДанных = Неопределено) Экспорт
	
	Если НЕ РаботаВМоделиСервиса.СеансЗапущенБезРазделителей()
		И ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() 
		И ОбластьДанных <> Неопределено Тогда
		
		ВызватьИсключение(НСтр("ru = 'Запрещено работать с данными области кроме текущей'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = РезервноеКопированиеОбластейДанныхПовтИсп.ПроксиКонтроляРезервногоКопирования();
	
	НастройкиXDTO = Неопределено;
	СообщениеОбОшибке = Неопределено;
	Если ОбластьДанных = Неопределено Тогда
		ОперацияВыполнена = Прокси.GetDefaultSettings(НастройкиXDTO, СообщениеОбОшибке);
	Иначе
		ОперацияВыполнена = Прокси.GetSettings(ОбластьДанных, НастройкиXDTO, СообщениеОбОшибке);
	КонецЕсли;
	
	Если НЕ ОперацияВыполнена Тогда
		ШаблонСообщения = НСтр("ru = 'Ошибка при получении настроек резервного копирования:
			|%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СообщениеОбОшибке);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
	Возврат НастройкиXDTOВСтруктуру(НастройкиXDTO);
	
КонецФункции	

// Записывает настройки резервного копирования области данных в хранилище менеджера сервиса.
//
// Параметры:
//   ОбластьДанных - Число - номер области данных,
//   НастройкиРезервногоКопирования - Структура - настройки.
//
// Возвращаемое значение:
//   Булево - признак успешности записи.
//
Процедура УстановитьНастройкиРезервногоКопированияОбласти(Знач ОбластьДанных, Знач НастройкиРезервногоКопирования) Экспорт
	
	Если НЕ РаботаВМоделиСервиса.СеансЗапущенБезРазделителей()
		И ОбластьДанных <> РаботаВМоделиСервиса.ЗначениеРазделителяСеанса() Тогда
		
		ВызватьИсключение(НСтр("ru = 'Запрещено работать с данными области кроме текущей'"));
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Прокси = РезервноеКопированиеОбластейДанныхПовтИсп.ПроксиКонтроляРезервногоКопирования();
	
	Тип = Прокси.ФабрикаXDTO.Тип("http://www.1c.ru/SaaS/1.0/XMLSchema/ZoneBackupControl", "Settings");
	НастройкиXDTO = Прокси.ФабрикаXDTO.Создать(Тип);
	
	СоответствиеИмен = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	Для Каждого ПараИменНастроек Из СоответствиеИмен Цикл
		НастройкиXDTO[ПараИменНастроек.Ключ] = НастройкиРезервногоКопирования[ПараИменНастроек.Значение];
	КонецЦикла;
	
	СообщениеОбОшибке = Неопределено;
	Если НЕ Прокси.SetSettings(ОбластьДанных, НастройкиXDTO, СообщениеОбОшибке) Тогда
		ШаблонСообщения = НСтр("ru = 'Ошибка при сохранении настроек резервного копирования:
                                |%1'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СообщениеОбОшибке);
		ВызватьИсключение(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Преобразования типов

// Параметры:
// 	НастройкиXDTO - ОбъектXDTO - настройки для преобразования.
// Возвращаемое значение:
// 	Структура, Неопределено - результат преобразования.
Функция НастройкиXDTOВСтруктуру(Знач НастройкиXDTO)
	
	Если НастройкиXDTO = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	СоответствиеИмен = РезервноеКопированиеОбластейДанныхПовтИсп.СоответствиеРусскихИменПолейНастроекАнглийским();
	Для Каждого ПараИменНастроек Из СоответствиеИмен Цикл
		Если НастройкиXDTO.Установлено(ПараИменНастроек.Ключ) Тогда
			Результат.Вставить(ПараИменНастроек.Значение, НастройкиXDTO[ПараИменНастроек.Ключ]);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат; 
	
КонецФункции

#КонецОбласти
