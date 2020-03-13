﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Удаляет устаревшие исправления, устанавливает корректные
// свойства новым исправлениям. Требуется вызывать перед выполнением обновления
// конфигурации в пакетном режиме (см. ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы).
// Важно: Выполненные действия применятся после перезапуска сеанса.
//
// Параметры:
//  ТолькоПроверка - Булево - если Истина, устаревшие патчи не будут удаляться.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//   * ЕстьИзменения     - Булево - истина, если были внесены изменения в составе исправлений.
//   * ОписаниеИзменений - Строка - информация о удаленных и измененных патчах.
//
Функция ИсправленияИзменены(ТолькоПроверка = Ложь) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьИзменения", Ложь);
	Результат.Вставить("ОписаниеИзменений", "");
	
	Если ОбщегоНазначения.ЭтоПодчиненныйУзелРИБ() Тогда
		// В подчиненном узле патчи изменяются при синхронизации.
		Возврат Результат;
	КонецЕсли;
	
	ИсправленияИзменены = Ложь;
	
	// Для расширений, которые подключились нужно проверять версию.
	Исправления = Новый Массив;
	Расширения = РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансАктивные);
	Для Каждого Расширение Из Расширения Цикл
		Если ЭтоИсправление(Расширение) Тогда
			Исправления.Добавить(Расширение);
		КонецЕсли;
	КонецЦикла;
	
	Изменения = Новый Структура;
	Изменения.Вставить("УдаленныеИсправления", Новый Массив);
	Изменения.Вставить("ОтключенаЗащита", Новый Массив);
	Изменения.Вставить("СнятБезопасныйРежим", Новый Массив);
	Изменения.Вставить("НеактивныеИсправления", Новый Массив);
	
	Если Исправления.Количество() > 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'В составе конфигурации обнаружены установленные исправления (%1).
			|Начало проверки необходимости удаления устаревших патчей.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Исправления.Количество());
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
		
		ОписанияПодсистем = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем();
		
		БиблиотекиКонфигурации = Новый Соответствие;
		Для Каждого Подсистема Из ОписанияПодсистем.ПоИменам Цикл
			БиблиотекиКонфигурации.Вставить(Подсистема.Ключ, Подсистема.Значение.Версия);
		КонецЦикла;
		
		Для Каждого Исправление Из Исправления Цикл
			УдалитьИсправление = Истина;
			СвойстваИсправления = СвойстваИсправления(Исправление.Имя);
			Если СвойстваИсправления = Неопределено Тогда
				// Исправление еще не применено.
				УдалитьИсправление = Ложь;
			Иначе
				ТекстСообщения = НСтр("ru = 'Проверка патча ""%1"".'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Исправление.Имя);
				ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
				
				Для Каждого ИнформацияОПрименимости Из СвойстваИсправления.AppliedFor Цикл
					ВерсияБиблиотекиКонфигурации = БиблиотекиКонфигурации.Получить(ИнформацияОПрименимости.ConfigurationName);
					
					Если ВерсияБиблиотекиКонфигурации <> Неопределено
						И СтрНайти(ИнформацияОПрименимости.Versions, ВерсияБиблиотекиКонфигурации) > 0 Тогда
						УдалитьИсправление = Ложь;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТолькоПроверка И УдалитьИсправление Тогда
				Результат.ЕстьИзменения = Истина;
				Возврат Результат;
			КонецЕсли;
			
			Если УдалитьИсправление Тогда
				ТекстСообщения = НСтр("ru = 'Патч ""%1"" устарел и будет удален.'");
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, Исправление.Имя);
				ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
				
				Попытка
					Исправление.Удалить();
					Изменения.УдаленныеИсправления.Добавить(Исправление.Имя);
					ИсправленияИзменены = Истина;
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось удалить исправление ""%1"" по причине:
						           |
						           |%2'"), Исправление.Имя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
					ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Удаление'", ОбщегоНазначения.КодОсновногоЯзыка()),
						УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
					ВызватьИсключение ТекстОшибки;
				КонецПопытки;
			Иначе
				ТребуетсяЗапись = Ложь;
				ЗащитаОтОпасныхДействий = ОбщегоНазначения.ОписаниеЗащитыБезПредупреждений();
				Если Исправление.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях
						<> ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях Тогда
					Исправление.ЗащитаОтОпасныхДействий = ЗащитаОтОпасныхДействий;
					ТребуетсяЗапись = Истина;
					Изменения.ОтключенаЗащита.Добавить(Исправление.Имя);
				КонецЕсли;
				Если Исправление.БезопасныйРежим <> Ложь Тогда
					Исправление.БезопасныйРежим = Ложь ;
					ТребуетсяЗапись = Истина;
					Изменения.СнятБезопасныйРежим.Добавить(Исправление.Имя);
				КонецЕсли;
				
				Если ТребуетсяЗапись Тогда
					Попытка
						Исправление.Записать();
						ИсправленияИзменены = Истина;
					Исключение
						ИнформацияОбОшибке = ИнформацияОбОшибке();
						ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
							НСтр("ru = 'При записи исправления ""%1"" произошла ошибка:
							           |
							           |%2'"), Исправление.Имя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
						ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Изменение'", ОбщегоНазначения.КодОсновногоЯзыка()),
							УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
						ВызватьИсключение ТекстОшибки;
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Неподключенные исправления удаляем без проверки версии.
	Расширения = РасширенияКонфигурации.Получить(, ИсточникРасширенийКонфигурации.СеансОтключенные);
	Для Каждого Расширение Из Расширения Цикл
		Если ЭтоИсправление(Расширение) Тогда
			Попытка
				Расширение.Удалить();
				Изменения.НеактивныеИсправления.Добавить(Расширение.Имя);
				ИсправленияИзменены = Истина;
			Исключение
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось удалить отключенное исправление ""%1"" по причине:
					           |
					           |%2'"), Расширение.Имя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Удаление'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
				ВызватьИсключение ТекстОшибки;
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Если Изменения.УдаленныеИсправления.Количество() > 0 Тогда
		ОсталосьИсправлений = Исправления.Количество() - Изменения.УдаленныеИсправления.Количество();
		ТекстСообщения = НСтр("ru = 'Удаление устаревших патчей завершено.
			|Удалено: %1
			|Осталось действующих патчей: %2'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			Изменения.УдаленныеИсправления.Количество(),
			ОсталосьИсправлений);
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
	КонецЕсли;
	
	ОписаниеИзменений = "";
	
	Если Изменения.УдаленныеИсправления.Количество() > 0 Тогда
		Заголовок = НСтр("ru = 'Удалены устаревшие патчи'");
		ОписаниеИзменений = Заголовок + ":" + Символы.ПС + СтрСоединить(Изменения.УдаленныеИсправления, Символы.ПС);
	КонецЕсли;
	Если Изменения.НеактивныеИсправления.Количество() > 0 Тогда
		Заголовок = НСтр("ru = 'Удалены неактивные патчи'");
		Если ЗначениеЗаполнено(ОписаниеИзменений) Тогда
			ОписаниеИзменений = ОписаниеИзменений + Символы.ПС + Символы.ПС;
		КонецЕсли;
		ОписаниеИзменений = ОписаниеИзменений + Заголовок + ":" + Символы.ПС + СтрСоединить(Изменения.НеактивныеИсправления, Символы.ПС);
	КонецЕсли;
	Если Изменения.ОтключенаЗащита.Количество() > 0 Тогда
		Заголовок = НСтр("ru = 'Отключены предупреждения об опасных действиях'");
		Если ЗначениеЗаполнено(ОписаниеИзменений) Тогда
			ОписаниеИзменений = ОписаниеИзменений + Символы.ПС + Символы.ПС;
		КонецЕсли;
		ОписаниеИзменений = ОписаниеИзменений + Заголовок + ":" + Символы.ПС + СтрСоединить(Изменения.ОтключенаЗащита, Символы.ПС);
	КонецЕсли;
	Если Изменения.СнятБезопасныйРежим.Количество() > 0 Тогда
		Заголовок = НСтр("ru = 'Отключен безопасный режим'");
		Если ЗначениеЗаполнено(ОписаниеИзменений) Тогда
			ОписаниеИзменений = ОписаниеИзменений + Символы.ПС + Символы.ПС;
		КонецЕсли;
		ОписаниеИзменений = ОписаниеИзменений + Заголовок + ":" + Символы.ПС + СтрСоединить(Изменения.СнятБезопасныйРежим, Символы.ПС);
	КонецЕсли;
	
	Результат.ЕстьИзменения = ИсправленияИзменены;
	Результат.ОписаниеИзменений = ОписаниеИзменений;
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

// Получает настройки обновления конфигурации.
//
// Возвращаемое значение:
//   Структура - со свойствами:
//     * РежимОбновления - Число - для файловой базы 0, для клиент-серверной 2.
//     * ДатаВремяОбновления - Дата - Дата запланированного обновления конфигурации.
//     * ВыслатьОтчетНаПочту - Булево - Признак необходимости отправки на электронную почту отчета об обновлении.
//     * АдресЭлектроннойПочты - Строка - Адрес электронной почты для отправки отчета обновлении.
//     * КодЗадачиПланировщика - Число - Код задачи планировщика Windows.
//     * ИмяФайлаОбновления - Строка - Имя файла, содержащего устанавливаемое обновление.
//     * СоздаватьРезервнуюКопию - Число - Признак необходимости создания резервной копии.
//     * ИмяКаталогаРезервнойКопииИБ - Строка - Каталог для создания резервной копии.
//     * ВосстанавливатьИнформационнуюБазу - Булево - Признак необходимости восстанавливать информационную базу
//                                                    в случае возникновения ошибок в процессе обновления.
//
Функция НастройкиОбновленияКонфигурации() Экспорт
	
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
	Настройки = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ОбновлениеКонфигурации", "НастройкиОбновленияКонфигурации");
	
	Если Настройки <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(НастройкиПоУмолчанию, Настройки);
	КонецЕсли;
	
	Возврат НастройкиПоУмолчанию;
	
КонецФункции

// Сохраняет настройки обновления конфигурации.
//
// Параметры:
//    Настройки - см. ОбновлениеКонфигурации.НастройкиОбновленияКонфигурации
//
Процедура СохранитьНастройкиОбновленияКонфигурации(Настройки) Экспорт
	
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(НастройкиПоУмолчанию, Настройки);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОбновлениеКонфигурации",
		"НастройкиОбновленияКонфигурации",
		НастройкиПоУмолчанию);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Работа с исправлениями (патчами).

// Возвращает информацию об установленных патчах в конфигурации.
//
// Возвращаемое значение:
//  Массив - структуры с ключами:
//     * Идентификатор - Строка - уникальный идентификатор исправления (патча).
//                     - Неопределено - если установка исправления выполнялась
//                                в текущем сеансе и еще не был выполнен перезапуск.
//     * Наименование  - Строка - наименование исправления.
//
Функция УстановленныеИсправления() Экспорт
	
	Результат = Новый Массив;
	УстановленныеРасширения = РасширенияКонфигурации.Получить(); // Массив из РасширениеКонфигурации
	Для Каждого Расширение Из УстановленныеРасширения Цикл
		Если Не ЭтоИсправление(Расширение) Тогда
			Продолжить;
		КонецЕсли;
		ИнформацияОбИсправлении = Новый Структура("Идентификатор, Наименование");
		СвойстваИсправления = СвойстваИсправления(Расширение.Имя);
		
		Если СвойстваИсправления <> Неопределено Тогда
			ИнформацияОбИсправлении.Идентификатор = СвойстваИсправления.UUID;
		КонецЕсли;
		ИнформацияОбИсправлении.Наименование  = Расширение.Имя;
		
		Результат.Добавить(ИнформацияОбИсправлении);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Производит установку/удаление патчей.
//
// Параметры:
//  Исправления - структура - с ключами:
//     * Установить - Массив - файлы исправлений во временном хранилище, которые требуется установить.
//     * Удалить    - Массив - уникальные идентификаторы (Строка) исправлений, которые требуется удалить.
//  ВФоне       - Булево - необходимо устанавливать в значение Истина, если вызов функции выполняется
//                         фоновом задании.
//
// Возвращаемое значение:
//  Структура - с ключами:
//     * Установленные - Массив - имена (Строка) установленных исправлений.
//     * НеУстановлено - Число - количество неустановленных исправлений.
//     * НеУдалено     - Число - количество неудаленных исправлений.
//
Функция УстановкаИУдалениеИсправлений(Исправления, ВФоне = Ложь) Экспорт
	
	Устанавливаемые = Неопределено;
	НеУстановлено   = 0;
	Установленные   = Новый Массив;
	Если Исправления.Свойство("Установить", Устанавливаемые)
		И Устанавливаемые <> Неопределено
		И Устанавливаемые.Количество() > 0 Тогда
		
		Для Каждого Патч Из Устанавливаемые Цикл
			Попытка
				// Чтение исправления из архива.
				ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
				Данные = ПолучитьИзВременногоХранилища(Патч); // ДвоичныеДанные
				Данные.Записать(ИмяАрхива);
				
				ИсправлениеНайдено = Ложь;
				ЧтениеZip = Новый ЧтениеZipФайла(ИмяАрхива);
				Для Каждого ЭлементАрхива Из ЧтениеZip.Элементы Цикл
					Если ЭлементАрхива.Расширение = "cfe" Тогда
						ИсправлениеНайдено = Истина;
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Если Не ИсправлениеНайдено Тогда
					ВызватьИсключение НСтр("ru = 'Исправление не найдено.'");
				КонецЕсли;
				
				ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог("Патчи");
				ИсправлениеПрименимо = ИсправлениеПрименимо(ЧтениеZip, ВременныйКаталог);
				Если Не ИсправлениеПрименимо Тогда
					ВызватьИсключение НСтр("ru = 'Исправление не применимо для данной версии конфигурации.'");
				КонецЕсли;
				ЧтениеZip.Извлечь(ЭлементАрхива, ВременныйКаталог);
				ЧтениеZip.Закрыть();
				ПолноеИмяИсправления = ВременныйКаталог + ЭлементАрхива.Имя;
				ДвоичныеДанныеИсправления = Новый ДвоичныеДанные(ПолноеИмяИсправления);
				
				Расширение = РасширенияКонфигурации.Создать();
				Справочники.ВерсииРасширений.ОтключитьПредупрежденияБезопасности(Расширение);
				Справочники.ВерсииРасширений.ОтключитьИспользованиеОсновныхРолейДляВсехПользователей(Расширение);
				Расширение.БезопасныйРежим = Ложь;
				Расширение.ИспользуетсяВРаспределеннойИнформационнойБазе = Истина;
				Расширение.Записать(ДвоичныеДанныеИсправления);
				
				УстановленноеИсправление = РасширениеПоИдентификатору(Расширение.УникальныйИдентификатор);
				Установленные.Добавить(УстановленноеИсправление.Имя);
				
				УдалитьФайлы(ИмяАрхива);
				УдалитьФайлы(ПолноеИмяИсправления);
			Исключение
				НеУстановлено = НеУстановлено + 1;
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'При установке исправления ""%1"" произошла ошибка:
					           |
					           |%2'"), Расширение.Имя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Установка'", ОбщегоНазначения.КодОсновногоЯзыка()),
					УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
				
				ФайловаяСистема.УдалитьВременныйФайл(ИмяАрхива);
				ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
			КонецПопытки;
		КонецЦикла;
		
	КонецЕсли;
	
	Удаляемые = Неопределено;
	НеУдалено = 0;
	Если Исправления.Свойство("Удалить", Удаляемые)
		И Удаляемые <> Неопределено
		И Удаляемые.Количество() > 0 Тогда
		ВсеРасширения = РасширенияКонфигурации.Получить();
		Для Каждого Расширение Из ВсеРасширения Цикл
			Если Не ЭтоИсправление(Расширение)
				Или Установленные.Найти(Расширение.Имя) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			Попытка
				СвойстваИсправления = СвойстваИсправления(Расширение.Имя);
				Идентификатор = СвойстваИсправления.UUID;
				Если Удаляемые.Найти(Строка(Идентификатор)) <> Неопределено Тогда
					Расширение.Удалить();
				КонецЕсли;
			Исключение
				НеУдалено = НеУдалено + 1;
				ИнформацияОбОшибке = ИнформацияОбОшибке();
				ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не удалось удалить исправление ""%1"" по причине:
					           |
					           |%2'"), Расширение.Имя, КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
				ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Удаление'", ОбщегоНазначения.КодОсновногоЯзыка())
					, УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
			КонецПопытки;
		КонецЦикла;
	КонецЕсли;
	
	ТекстДляАсинхронногоВызова = "";
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() И ВФоне Тогда
		ТекстДляАсинхронногоВызова = НСтр("ru = 'Обновление параметров работы расширений после установки или
			|удаления патчей завершилось с ошибкой.'")
	КонецЕсли;
	
#Если Не ВнешнееСоединение Тогда
	РегистрыСведений.ПараметрыРаботыВерсийРасширений.ОбновитьПараметрыРаботыРасширений(Неопределено, "", ТекстДляАсинхронногоВызова);
#КонецЕсли
	
	Результат = Новый Структура;
	Результат.Вставить("НеУстановлено", НеУстановлено);
	Результат.Вставить("НеУдалено", НеУдалено);
	Результат.Вставить("Установленные", Установленные);
	
	Возврат Результат;
	
КонецФункции

// Проверка, показывающая есть ли расширения, требующие отображение 
// предупреждения об имеющихся расширениях.
// Проверяет наличие расширений не являющихся исправлениями (патчами).
//
// Возвращаемое значение:
//  Булево - результат проверки.
//
Функция ПредупреждатьОНаличииРасширений() Экспорт 
	
	ВсеРасширения = РасширенияКонфигурации.Получить();
	
	Для Каждого Расширение Из ВсеРасширения Цикл
		Если Не ЭтоИсправление(Расширение) Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

// Конец ИнтернетПоддержкаПользователей.ПолучениеОбновленийПрограммы

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПроверитьНаличиеУстаревшихИсправлений() Экспорт
	Результат = ИсправленияИзменены(Истина);
	Если Результат.ЕстьИзменения Тогда
		ТекстСообщения = НСтр("ru = 'Некорректный вызов функции ""ОбновлениеИнформационнойБазы.ВыполнитьОбновлениеИнформационнойБазы"".
			|Перед вызовом не были удалены устаревшие патчи, возможно, обновление выполняется нештатными средствами.'");
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
	КонецЕсли;
КонецПроцедуры

// Вызывается при завершении обновления конфигурации через COM-соединение.
//
// Параметры:
//  РезультатОбновления  - Булево - Результат обновления.
//
Процедура ЗавершитьОбновление(Знач РезультатОбновления, Знач ЭлектроннаяПочта, Знач ИмяАдминистратораОбновления, Знач КаталогСкрипта = Неопределено) Экспорт

	ТекстСообщения = НСтр("ru = 'Завершение обновления из внешнего скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
	
	Если Не ЕстьПраваНаУстановкуОбновления() Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав для завершения обновления конфигурации.'");
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Если КаталогСкрипта = Неопределено Тогда 
		КаталогСкрипта = КаталогСкрипта();
	КонецЕсли;
	
	ЗаписатьСтатусОбновления(ИмяАдминистратораОбновления, Ложь, Истина, РезультатОбновления, КаталогСкрипта);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями")
		И Не ПустаяСтрока(ЭлектроннаяПочта) Тогда
		Попытка
			ОтправитьУведомлениеОбОбновлении(ИмяАдминистратораОбновления, ЭлектроннаяПочта, РезультатОбновления);
			ТекстСообщения = НСтр("ru = 'Уведомление об обновлении успешно отправлено на адрес электронной почты:'")
				+ " " + ЭлектроннаяПочта;
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,,ТекстСообщения);
		Исключение
			ТекстСообщения = НСтр("ru = 'Ошибка при отправке письма электронной почты:'")
				+ " " + ЭлектроннаяПочта + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
			ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения);
		КонецПопытки;
	КонецЕсли;
	
	Если РезультатОбновления Тогда
		ОбновлениеИнформационнойБазыСлужебный.ПослеЗавершенияОбновления();
	КонецЕсли;
	
КонецПроцедуры

Функция КаталогСкрипта() Экспорт
	
	КаталогСкрипта = "";
	
	Если Не ОбщегоНазначения.РазделениеВключено() Тогда 
		СтатусОбновления = СтатусОбновленияКонфигурации();
		Если СтатусОбновления <> Неопределено И СтатусОбновления.Свойство("КаталогСкрипта") Тогда
			КаталогСкрипта = СтатусОбновления.КаталогСкрипта;
			
			СтатусОбновления.КаталогСкрипта = "";
			УстановитьСтатусОбновленияКонфигурации(СтатусОбновления); 
		КонецЕсли;
	КонецЕсли;
	
	Если Не ПустаяСтрока(КаталогСкрипта) Тогда
		// Если каталог уже удален, то считаем, что поведение как при обычном обновлении из конфигуратора.
		ФайлИнфо = Новый Файл(КаталогСкрипта);
		Если Не ФайлИнфо.Существует() Тогда 
			КаталогСкрипта = "";
		КонецЕсли;
	КонецЕсли;
	
	Возврат КаталогСкрипта;
	
КонецФункции

// Возвращает полное имя основной формы обработки УстановкаОбновлений.
//
Функция ИмяФормыУстановкиОбновления() Экспорт
	
	Возврат "Обработка.УстановкаОбновлений.Форма.Форма";
	
КонецФункции

// Зачитывает свойства исправления из макета. Имя макет должно совпадать с именем исправления.
// Формат макеты XML. Соответствует XDTO пакету ErrorFix.
//
Функция СвойстваИсправления(ИмяИсправления) Экспорт
	
	Если Метаданные.ОбщиеМакеты.Найти(ИмяИсправления) = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтрокаXML = ПолучитьОбщийМакет(ИмяИсправления).ПолучитьТекст();
	
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(СтрокаXML);
	
	Возврат ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.v8.1c.ru/ssl/patch", "Patch"));
	
КонецФункции

Функция ЭтоИсправление(Расширение) Экспорт
	
	Возврат Расширение.Назначение = Метаданные.СвойстваОбъектов.НазначениеРасширенияКонфигурации.Исправление
		И СтрНачинаетсяС(Расширение.Имя, "EF");
	
КонецФункции

Процедура ОбновитьИсправленияИзСкрипта(НовыеИсправления, УдаляемыеИсправления) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Обновление исправлений конфигурации из внешнего скрипта.'");
	ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,,, ТекстСообщения);
	
	Если Не ЕстьПраваНаУстановкуОбновления() Тогда
		ТекстСообщения = НСтр("ru = 'Недостаточно прав для обновления исправлений конфигурации.'");
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	ИсправленияИзменены();
	
	УстанавливаемыеИсправления = Новый Массив;
	Если ЗначениеЗаполнено(НовыеИсправления) Тогда
		НовыеИсправленияМассив = СтрРазделить(НовыеИсправления, Символы.ПС);
		Для Каждого Исправление Из НовыеИсправленияМассив Цикл
			ДанныеИсправления = Новый ДвоичныеДанные(Исправление);
			УстанавливаемыеИсправления.Добавить(ПоместитьВоВременноеХранилище(ДанныеИсправления));
		КонецЦикла;
	КонецЕсли;
	
	УдаляемыеИсправленияМассив = Новый Массив;
	Если ЗначениеЗаполнено(УдаляемыеИсправления) Тогда
		УдаляемыеИсправленияМассив = СтрРазделить(УдаляемыеИсправления, Символы.ПС);
	КонецЕсли;
	
	Исправления = Новый Структура("Установить, Удалить", УстанавливаемыеИсправления, УдаляемыеИсправленияМассив);
	Результат = УстановкаИУдалениеИсправлений(Исправления);
	Результат.Вставить("ВсегоПатчей", УстанавливаемыеИсправления.Количество());
	
	Статус = СтатусОбновленияКонфигурации();
	Если Статус = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Не Статус.Свойство("РезультатУстановкиПатчей") Тогда
		Статус.Вставить("РезультатУстановкиПатчей");
	КонецЕсли;
	Статус.РезультатУстановкиПатчей = Результат;
	УстановитьСтатусОбновленияКонфигурации(Статус);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбновлениеИнформационнойБазыБСП.ПослеОбновленияИнформационнойБазы.
Процедура ПослеОбновленияИнформационнойБазы() Экспорт
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	Статус = СтатусОбновленияКонфигурации();
	Если Статус <> Неопределено И Статус.ОбновлениеВыполнено И Статус.РезультатОбновленияКонфигурации <> Неопределено
		И Не Статус.РезультатОбновленияКонфигурации Тогда
		
		Статус.РезультатОбновленияКонфигурации = Истина;
		УстановитьСтатусОбновленияКонфигурации(Статус);
		
	КонецЕсли;
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиентаПриЗапуске.
Процедура ПриДобавленииПараметровРаботыКлиентаПриЗапуске(Параметры) Экспорт
	
	ПриДобавленииПараметровРаботыКлиента(Параметры);
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПараметровРаботыКлиента.
Процедура ПриДобавленииПараметровРаботыКлиента(Параметры) Экспорт
	
	Если Не ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных()
		Или Не ОбщегоНазначения.ЭтоWindowsКлиент() Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Вставить("НастройкиОбновления", Новый ФиксированнаяСтруктура(НастройкиОбновления()));

КонецПроцедуры

Процедура ПроверитьСтатусОбновления(РезультатОбновления, КаталогСкрипта, УстановленныеИсправления) Экспорт
	
	// Если это первый запуск после обновления конфигурации, то запоминаем и сбрасываем статус.
	РезультатОбновления = ОбновлениеКонфигурацииУспешно(КаталогСкрипта, УстановленныеИсправления);
	Если РезультатОбновления <> Неопределено Тогда
		СброситьСтатусОбновленияКонфигурации();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получить глобальные настройки обновления на сеанс 1С:Предприятия.
//
Функция НастройкиОбновления()
	
	Настройки = Новый Структура;
	Настройки.Вставить("КонфигурацияИзменена",?(ЕстьПраваНаУстановкуОбновления(), КонфигурацияИзменена(), Ложь));
	Настройки.Вставить("ПроверитьПрошлыеОбновленияБазы", ОбновлениеКонфигурацииУспешно() <> Неопределено);
	Настройки.Вставить("НастройкиОбновленияКонфигурации", НастройкиОбновленияКонфигурации());
	
	Возврат Настройки;
	
КонецФункции

// Возвращает признак успешного обновления конфигурации на основе данных константы настроек.
Функция ОбновлениеКонфигурацииУспешно(КаталогСкрипта = "", УстановленныеИсправления = "") Экспорт

	Если Не ПравоДоступа("Чтение", Метаданные.Константы.СтатусОбновленияКонфигурации) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Статус = СтатусОбновленияКонфигурации();
	Если Статус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И Не Статус.ОбновлениеВыполнено
		Или (Статус.ИмяАдминистратораОбновления <> ИмяПользователя()) Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Если Статус.РезультатОбновленияКонфигурации <> Неопределено Тогда
		Статус.Свойство("КаталогСкрипта", КаталогСкрипта);
		Статус.Свойство("РезультатУстановкиПатчей", УстановленныеИсправления);
	КонецЕсли;
	
	Возврат Статус.РезультатОбновленияКонфигурации;

КонецФункции

// Устанавливает новое значение в константу настроек обновления
// соответственно успешности последней попытки обновления конфигурации.
Процедура ЗаписатьСтатусОбновления(Знач ИмяАдминистратораОбновления, Знач ОбновлениеЗапланировано,
	Знач ОбновлениеВыполнено, Знач РезультатОбновления, КаталогСкрипта = "", СообщенияДляЖурналаРегистрации = Неопределено) Экспорт
	
	ЖурналРегистрации.ЗаписатьСобытияВЖурналРегистрации(СообщенияДляЖурналаРегистрации);
	
	Статус = Новый Структура;
	Статус.Вставить("ИмяАдминистратораОбновления", ИмяАдминистратораОбновления);
	Статус.Вставить("ОбновлениеЗапланировано", ОбновлениеЗапланировано);
	Статус.Вставить("ОбновлениеВыполнено", ОбновлениеВыполнено);
	Статус.Вставить("РезультатОбновленияКонфигурации", РезультатОбновления);
	Статус.Вставить("КаталогСкрипта", КаталогСкрипта);
	Статус.Вставить("РезультатУстановкиПатчей", Неопределено);
	
	СтарыйСтатус = СтатусОбновленияКонфигурации();
	Если СтарыйСтатус <> Неопределено
		И СтарыйСтатус.Свойство("РезультатУстановкиПатчей")
		И СтарыйСтатус.РезультатУстановкиПатчей <> Неопределено Тогда
		Статус.РезультатУстановкиПатчей = СтарыйСтатус.РезультатУстановкиПатчей;
	КонецЕсли;
	
	УстановитьСтатусОбновленияКонфигурации(Статус);
	
КонецПроцедуры

Процедура СброситьСтатусОбновленияКонфигурации() Экспорт
	
	УстановитьСтатусОбновленияКонфигурации(Неопределено);
	
КонецПроцедуры

Функция ЕстьПраваНаУстановкуОбновления() Экспорт
	Возврат Пользователи.ЭтоПолноправныйПользователь(, Истина);
КонецФункции

Процедура ОтправитьУведомлениеОбОбновлении(Знач ИмяПользователя, Знач АдресНазначения, Знач УспешноеОбновление)
	
	Тема = ? (УспешноеОбновление, НСтр("ru = 'Успешное обновление конфигурации ""%1"", версия %2'"), 
		НСтр("ru = 'Ошибка обновления конфигурации ""%1"", версия %2'"));
	Тема = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Тема, Метаданные.КраткаяИнформация, Метаданные.Версия);
	
	Подробности = ?(УспешноеОбновление, НСтр("ru = 'Обновление конфигурации завершено успешно.'"), 
		НСтр("ru = 'При обновлении конфигурации произошли ошибки. Подробности записаны в журнал регистрации.'"));
	Текст = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1
		|
		|Конфигурация: %2
		|Версия: %3
		|Строка соединения: %4'"),
	Подробности, Метаданные.КраткаяИнформация, Метаданные.Версия, СтрокаСоединенияИнформационнойБазы());
	
	ПараметрыПисьма = Новый Структура;
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Тело", Текст);
	ПараметрыПисьма.Вставить("Кому", АдресНазначения);
	
	МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
	УчетнаяЗапись = МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	Письмо = МодульРаботаСПочтовымиСообщениями.ПодготовитьПисьмо(УчетнаяЗапись, ПараметрыПисьма);
	МодульРаботаСПочтовымиСообщениями.ОтправитьПисьмо(УчетнаяЗапись, Письмо);
	
КонецПроцедуры

Функция СобытиеЖурналаРегистрации()
	Возврат НСтр("ru = 'Обновление конфигурации'", ОбщегоНазначения.КодОсновногоЯзыка());
КонецФункции

Функция НастройкиПоУмолчанию()
	
	Результат = Новый Структура;
	Результат.Вставить("РежимОбновления", ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(), 0, 2));
	Результат.Вставить("ДатаВремяОбновления", НачалоДня(ТекущаяДатаСеанса()) + 24*60*60);
	Результат.Вставить("ВыслатьОтчетНаПочту", Ложь);
	Результат.Вставить("АдресЭлектроннойПочты", "");
	Результат.Вставить("КодЗадачиПланировщика", 0);
	Результат.Вставить("ИмяФайлаОбновления", "");
	Результат.Вставить("СоздаватьРезервнуюКопию", 1);
	Результат.Вставить("ИмяКаталогаРезервнойКопииИБ", "");
	Результат.Вставить("ВосстанавливатьИнформационнуюБазу", Истина);
	Результат.Вставить("ФайлыИсправлений", Новый Массив);
	Результат.Вставить("Исправления", Неопределено);
	Возврат Результат;

КонецФункции

Функция ВыполнитьОтложенныеОбработчики() Экспорт
	
	Возврат Не СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
		И ОбновлениеИнформационнойБазыСлужебный.СтатусНевыполненныхОбработчиков() = "СтатусНеВыполнено";
	
КонецФункции

Функция УстановитьИсправления(Знач ПомещенныеФайлы) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ЕстьОшибки", Ложь);
	Результат.Вставить("УстановленоИсправлений", 0);
	
	Для Каждого ФайлИсправления Из ПомещенныеФайлы Цикл
		
		Попытка
			Если СтрЗаканчиваетсяНа(ФайлИсправления.Имя, ".zip") Тогда
				Данные = ИзвлечьИсправлениеИзАрхива(ФайлИсправления);
			Иначе
				Данные = ПолучитьИзВременногоХранилища(ФайлИсправления.Хранение);
			КонецЕсли;
			
			Расширение = РасширенияКонфигурации.Создать();
			Справочники.ВерсииРасширений.ОтключитьПредупрежденияБезопасности(Расширение);
			Справочники.ВерсииРасширений.ОтключитьИспользованиеОсновныхРолейДляВсехПользователей(Расширение);
			Расширение.БезопасныйРежим = Ложь;
			Расширение.ИспользуетсяВРаспределеннойИнформационнойБазе = Истина;
			Расширение.Записать(Данные);
			
			УстановленноеРасширение = РасширениеПоИдентификатору(Расширение.УникальныйИдентификатор);
			Если Не ЭтоИсправление(УстановленноеРасширение) Тогда
				Расширение.Удалить();
				ВызватьИсключение НСтр("ru = 'Расширение не является патчем.'");
			КонецЕсли;
			Результат.УстановленоИсправлений = Результат.УстановленоИсправлений + 1;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Результат.ЕстьОшибки = Истина;
			
			Если Данные = Неопределено Тогда
				ИмяФайлаИсправления = ФайлИсправления.Имя;
			Иначе
				ОписаниеИсправления = Новый ОписаниеКонфигурации(Данные);
				ИмяФайлаИсправления = ОписаниеИсправления.Имя;
			КонецЕсли;
			
			ТекстОшибки = НСтр("ru = 'При установке исправления %1 возникла ошибка:
			|%2'");
			ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОшибки, ИмяФайлаИсправления,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ЗаписьЖурналаРегистрации(НСтр("ru = 'Исправления.Установка'", ОбщегоНазначения.КодОсновногоЯзыка()),
				УровеньЖурналаРегистрации.Ошибка,,, ТекстОшибки);
		КонецПопытки;
	КонецЦикла;

	РегистрыСведений.ПараметрыРаботыВерсийРасширений.ОбновитьПараметрыРаботыРасширений();
	Возврат Результат;
	
КонецФункции

Функция ИзвлечьИсправлениеИзАрхива(Знач ПомещенныйФайл)
	
	ИмяАрхива = ПолучитьИмяВременногоФайла("zip");
	Попытка
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ПомещенныйФайл.Хранение); // ДвоичныеДанные
		ДвоичныеДанные.Записать(ИмяАрхива);
		
		ИсправлениеНайдено = Ложь;
		ЧтениеZip = Новый ЧтениеZipФайла(ИмяАрхива);
		Для Каждого ЭлементАрхива Из ЧтениеZip.Элементы Цикл
			Если ЭлементАрхива.Расширение = "cfe" Тогда
				ИсправлениеНайдено = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		Если Не ИсправлениеНайдено Тогда
			ВызватьИсключение НСтр("ru = 'Файл не является исправлением.'");
		КонецЕсли;
		
		ВременныйКаталог = ФайловаяСистема.СоздатьВременныйКаталог("Патчи");
		
		// Проверка применимости.
		ИсправлениеПрименимо = ИсправлениеПрименимо(ЧтениеZip, ВременныйКаталог);
		Если Не ИсправлениеПрименимо Тогда
			ВызватьИсключение НСтр("ru = 'Исправление не применимо для данной версии конфигурации.'");
		КонецЕсли;
		
		ЧтениеZip.Извлечь(ЭлементАрхива, ВременныйКаталог);
		ЧтениеZip.Закрыть();
		
		ПолноеИмяИсправления = ВременныйКаталог + ЭлементАрхива.Имя;
		Данные = Новый ДвоичныеДанные(ПолноеИмяИсправления);
		
		ФайловаяСистема.УдалитьВременныйФайл(ИмяАрхива);
		ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
	Исключение
		ФайловаяСистема.УдалитьВременныйФайл(ИмяАрхива);
		Если ИсправлениеНайдено Тогда
			ФайловаяСистема.УдалитьВременныйКаталог(ВременныйКаталог);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Данные;
	
КонецФункции

Функция ИсправлениеПрименимо(ЧтениеZip, ВременныйКаталог)
	ФайлМанифеста = ЧтениеZip.Элементы.Найти("Manifest.xml");
	Если ФайлМанифеста = Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.РежимОтладки() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Попытка
		ЧтениеZip.Извлечь(ФайлМанифеста, ВременныйКаталог);
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ВременныйКаталог + ФайлМанифеста.Имя);
		
		ЧтениеXML = Новый ЧтениеXML;
		ЧтениеXML.УстановитьСтроку(ТекстовыйДокумент.ПолучитьТекст());
		Свойства = ФабрикаXDTO.ПрочитатьXML(ЧтениеXML, ФабрикаXDTO.Тип("http://www.v8.1c.ru/ssl/patch", "Patch"));
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ВызватьИсключение НСтр("ru = 'Ошибка при чтении файла манифеста исправления'") + ":" + Символы.ПС + ТекстОшибки;
	КонецПопытки;
	
	ОписанияПодсистем = СтандартныеПодсистемыПовтИсп.ОписанияПодсистем();
	
	Для Каждого ИнформацияОПрименимости Из Свойства.AppliedFor Цикл
		Если ИнформацияОПрименимости.ConfigurationName = "БиблиотекаСтандартныхПодсистем" Тогда
			ИнформацияОПрименимости.ConfigurationName = "СтандартныеПодсистемы";
		КонецЕсли;
		ВерсияБиблиотекиКонфигурации = ОписанияПодсистем.ПоИменам.Получить(ИнформацияОПрименимости.ConfigurationName);
		
		Если ВерсияБиблиотекиКонфигурации <> Неопределено
			И СтрНайти(ИнформацияОПрименимости.Versions, ВерсияБиблиотекиКонфигурации.Версия) > 0 Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
КонецФункции

// Параметры:
//  Идентификатор - УникальныйИдентификатор - 
//
// Возвращаемое значение:
//  РасширениеКонфигурации - 
//
Функция РасширениеПоИдентификатору(Идентификатор)
	Отбор = Новый Структура;
	Отбор.Вставить("УникальныйИдентификатор", Идентификатор);
	Возврат РасширенияКонфигурации.Получить(Отбор)[0];
КонецФункции

Функция СведенияОбОбновлении(Знач ИмяФайлаПоставкиОбновления) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("Подходит", Ложь);
	ИсходныеКонфигурации = Новый ДеревоЗначений;
	ИсходныеКонфигурации.Колонки.Добавить("Версия", Новый ОписаниеТипов("Строка"));
	Результат.Вставить("ИсходныеКонфигурации", ИсходныеКонфигурации);
	
	Попытка
		ДанныеФайла = Новый ДвоичныеДанные(ИмяФайлаПоставкиОбновления);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Результат.ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Результат;
	КонецПопытки;
	
	Попытка
		Описание = Новый ОписаниеОбновленияКонфигурации(ДанныеФайла);
	Исключение
		ЗаписьЖурналаРегистрации(СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Результат.ТекстОшибки = НСтр("ru = 'Сведения не доступны'");
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
			Результат.ТекстОшибки = Результат.ТекстОшибки + " (" + КраткоеПредставлениеОшибки + ")";
		КонецЕсли;	
		Возврат Результат;
	КонецПопытки;
	
	Для каждого ИсходнаяКонфигурация Из Описание.ИсходныеКонфигурации Цикл
		
		Если Не Результат.Подходит
			И (ИсходнаяКонфигурация.Имя = Метаданные.Имя И ИсходнаяКонфигурация.Поставщик = Метаданные.Поставщик
			И ИсходнаяКонфигурация.Версия = Метаданные.Версия) Тогда
			Результат.Подходит = Истина;
		КонецЕсли;
		
		ИмяКонфигурации = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 (%2)", 
			ИсходнаяКонфигурация.Имя, ИсходнаяКонфигурация.Поставщик);
		ЭлементКонфигурация = ИсходныеКонфигурации.Строки.Найти(ИмяКонфигурации, "Версия", Ложь);
		Если ЭлементКонфигурация = Неопределено Тогда
			ЭлементКонфигурация = ИсходныеКонфигурации.Строки.Добавить();
			ЭлементКонфигурация.Версия = ИмяКонфигурации; 
		КонецЕсли;
		ВерсияКонфигурации = ЭлементКонфигурация.Строки.Добавить();
		ВерсияКонфигурации.Версия = ИсходнаяКонфигурация.Версия;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

Функция СтатусОбновленияКонфигурации()
	
	ЗначениеХранилища = Константы.СтатусОбновленияКонфигурации.Получить();
	Если ЗначениеХранилища = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;	
	Возврат ЗначениеХранилища.Получить();
	
КонецФункции

Функция УстановитьСтатусОбновленияКонфигурации(Знач Статус)
	
	Константы.СтатусОбновленияКонфигурации.Установить(Новый ХранилищеЗначения(Статус));
	
КонецФункции

#КонецОбласти
