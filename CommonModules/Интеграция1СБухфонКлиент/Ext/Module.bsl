﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Бухфон".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура устанавливает свойства элемента кнопки при встраивании в другие подсистемы.
//
Процедура ОбработкаОповещения(ИмяСобытия, Элемент) Экспорт
	
	Если ИмяСобытия = "СохранениеНастроек1СБухфон" Тогда
		НастройкиПользователя = Интеграция1СБухфонВызовСервера.НастройкиУчетнойЗаписиПользователя();
		Элемент.Видимость = НастройкиПользователя.ВидимостьКнопки1СБухфон;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область СлужебныеПроцедурыИФункции

// Возвращает уникальный идентификатор клиента 1С (приложение).
Функция ИдентификаторКлиента() Экспорт
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ИдентификаторКлиента = СистемнаяИнформация.ИдентификаторКлиента;
	Возврат ИдентификаторКлиента;
	
КонецФункции

// Возвращает путь файла приложения в реестре Windows.
// 
Функция ПутьКИсполняемомуФайлуИзРеестраWindows() Экспорт
	
	Значение = "";
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		Возврат Значение;
	КонецЕсли;
	
#Если ВебКлиент Тогда
	ЗначениеИзРеестра = "";
#Иначе
	RegProv = ПолучитьCOMОбъект("winmgmts:{impersonationLevel=impersonate}!\\.\root\default:StdRegProv");
	RegProv.GetStringValue("2147483649","Software\Buhphone","ProgramPath",Значение);
	
	Если Значение = "" Или  Значение = NULL Тогда
		ЗначениеИзРеестра = "";
	Иначе
		ЗначениеИзРеестра = Значение;
	КонецЕсли;
	
	Возврат ЗначениеИзРеестра;
#КонецЕсли
	
КонецФункции

// Диалоговое окно для выбора файла.
//
// Возвращаемое значение:
//		Строка  - Путь к исполняемому файлу.
Процедура ВыбратьФайл1СБухфон(ОповещениеОЗакрытии, ПутьКФайлу = "") Экспорт
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОповещениеОЗакрытии", ОповещениеОЗакрытии);
	ДополнительныеПараметры.Вставить("ПутьКФайлу", ПутьКФайлу);
	
	ТекстПредложения = НСтр("ru = 'Для выбора приложения необходимо установить расширение работы с файлами.'");
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайл1СБухфонПослеУстановкиРасширения", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВыбратьФайл1СБухфонПослеУстановкиРасширения(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Не Подключено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, "");
		Возврат;
	КонецЕсли;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = НСтр("ru = 'Выберите исполняемый файл приложения'");
	Диалог.ПолноеИмяФайла = ДополнительныеПараметры.ПутьКФайлу;
	Каталог = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ДополнительныеПараметры.ПутьКФайлу);
	Диалог.Каталог = Каталог.Путь;
	Фильтр = НСтр("ru = 'Файл приложения (*.exe)|*.exe'");
	Диалог.Фильтр = Фильтр;
	Диалог.МножественныйВыбор = Ложь;
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьФайл1СБухфонЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура ВыбратьФайл1СБухфонЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено И ВыбранныеФайлы.Количество() > 0 Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, ВыбранныеФайлы[0]);
	Иначе
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеОЗакрытии, "");
	КонецЕсли;
КонецПроцедуры

// Проверяет наличие исполняемого файла по указанному пути.
//
// Возвращаемое значение:
// 		Булево  - При значении Истина файл запустится по указанному пути.
//
Процедура НаличиеФайла1СБухфон(ОповещениеОЗакрытии, Путь)
	Оповещение = Новый ОписаниеОповещения("НаличиеФайла1СБухфонПослеИнициализацииФайла", ЭтотОбъект, ОповещениеОЗакрытии);
	ПроверяемыйФайл = Новый Файл();
	ПроверяемыйФайл.НачатьИнициализацию(Оповещение, Путь);
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура НаличиеФайла1СБухфонПослеИнициализацииФайла(Файл, ОповещениеОЗакрытии) Экспорт
	Оповещение = Новый ОписаниеОповещения("НаличиеФайла1СБухфонПослеПроверкиСуществования", ЭтотОбъект, ОповещениеОЗакрытии);
	Файл.НачатьПроверкуСуществования(Оповещение);
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура НаличиеФайла1СБухфонПослеПроверкиСуществования(Существует, ОповещениеОЗакрытии) Экспорт
	ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, Существует);
КонецПроцедуры

// Процедура запускает исполняемый файл приложения.
// При отсутствии файла приложения - открывает форму поиска пути к исполняемому файлу.
//
Процедура Запустить1СБухфон() Экспорт
	
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоWindowsКлиент() Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Для работы с приложением необходима операционная система Microsoft Windows.'"));
		Возврат
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("Запустить1СБухфонПослеУстановкиРасширения", ЭтотОбъект);
	ТекстСообщения = НСтр("ru = 'Для запуска приложения необходимо установить расширение работы с файлами.'");
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстСообщения, Ложь);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура Запустить1СБухфонПослеУстановкиРасширения(РасширениеПодключено, ДополнительныеПараметры) Экспорт
	
	Если НЕ РасширениеПодключено Тогда
		Возврат;
	КонецЕсли;
	
	// Определение параметров запуска.
	ИдентификаторКлиента = ИдентификаторКлиента();
	ПутьИзРеестра = ПутьКИсполняемомуФайлуИзРеестраWindows();
	ПутьИзХранилища = Интеграция1СБухфонВызовСервера.РасположениеИсполняемогоФайла(ИдентификаторКлиента);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПутьИзРеестра", ПутьИзРеестра);
	ДополнительныеПараметры.Вставить("ПутьИзХранилища", ПутьИзХранилища);
	
	Оповещение = Новый ОписаниеОповещения("Запустить1СБухфонПослеПроверкиПутиИзРеестра", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайла1СБухфон(Оповещение, ПутьИзРеестра);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура Запустить1СБухфонПослеПроверкиПутиИзРеестра(ПутьИзРеестраВерен, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.Вставить("ПутьИзРеестраВерен", ПутьИзРеестраВерен);
	Оповещение = Новый ОписаниеОповещения("Запустить1СБухфонПослеПроверкиПутиИзХранилища", ЭтотОбъект, ДополнительныеПараметры);
	НаличиеФайла1СБухфон(Оповещение, ДополнительныеПараметры.ПутьИзХранилища);
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура Запустить1СБухфонПослеПроверкиПутиИзХранилища(ПутьИзХранилищаВерен, ДополнительныеПараметры) Экспорт
	
	УчетнаяЗапись = Интеграция1СБухфонВызовСервера.НастройкиУчетнойЗаписиПользователя();
	ПараметрыЗапуска1СБухфон = " /StartedFrom1CConf";
	
	Оповещение = Новый ОписаниеОповещения("Запустить1СБухфонПослеЗапускаПриложения", ЭтотОбъект);
	Если УчетнаяЗапись.ИспользоватьЛП Тогда
		
		Если УчетнаяЗапись.Логин <> "" И УчетнаяЗапись.Пароль <> "" Тогда
			ПараметрыЗапуска1СБухфон = ПараметрыЗапуска1СБухфон + " /login:" + УчетнаяЗапись.Логин + " /password:" + УчетнаяЗапись.Пароль;
		КонецЕсли;
		
		Если ПутьИзХранилищаВерен Тогда
			НачатьЗапускПриложения(Оповещение, ДополнительныеПараметры.ПутьИзХранилища + ПараметрыЗапуска1СБухфон);
			Возврат;
		КонецЕсли;
		
		Если ДополнительныеПараметры.ПутьИзРеестраВерен Тогда
			НачатьЗапускПриложения(Оповещение, ДополнительныеПараметры.ПутьИзРеестра + ПараметрыЗапуска1СБухфон);
			Возврат;
		КонецЕсли;
		
	Иначе
		
		Если ПутьИзХранилищаВерен Тогда
			НачатьЗапускПриложения(Оповещение, """" + ДополнительныеПараметры.ПутьИзХранилища + """" + ПараметрыЗапуска1СБухфон);
			Возврат;
		КонецЕсли;
		
		Если ДополнительныеПараметры.ПутьИзРеестраВерен Тогда
			НачатьЗапускПриложения(Оповещение, """" + ДополнительныеПараметры.ПутьИзРеестра + """" + ПараметрыЗапуска1СБухфон);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ПоискИсполняемогоФайла1СБухфон");
	
КонецПроцедуры

// Продолжение процедуры (см. выше).
Процедура Запустить1СБухфонПослеЗапускаПриложения(КодВозврата, ДополнительныеПараметры) Экспорт
	// Обработка не требуется.
КонецПроцедуры

#КонецОбласти





 