﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2019, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "Присоединенные файлы".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ОткрытьФайл.
// Открывает файл для просмотра или редактирования.
//  Если файл открывается для просмотра, тогда получает файл в рабочий каталог пользователя,
// при этом ищет файл в рабочем каталоге и предлагает открыть существующий или получить файл с сервера.
//  Если файл открывается для редактирования, тогда открывает файл в рабочем каталоге (если есть) или
// получает его с сервера.
//
// Параметры:
//  ДанныеФайла       - Структура - данные файла.
//  ДляРедактирования - Булево - Истина, если файл открывается для редактирования, иначе Ложь.
//
Процедура ОткрытьФайл(Знач ДанныеФайла, Знач ДляРедактирования = Ложь) Экспорт
	
	РаботаСФайламиКлиент.ОткрытьФайл(ДанныеФайла, ДляРедактирования);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ДобавитьФайлы.
// Обработчик команды добавления файлов.
//  Предлагает пользователю выбирать файлы в диалоге выбора файлов и
// пытается поместить выбранные файлы в хранилище файлов, когда:
// - размер файла не превышает максимально допустимый,
// - файл имеет допустимое расширение,
// - имеется свободное место в томе (при хранении файлов в томах),
// - прочие условия.
//
// Параметры:
//  ВладелецФайла      - Ссылка - владелец файла.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//  Фильтр             - Строка - необязательный параметр,
//                       позволяет задать фильтр выбираемого файла,
//                       например, картинки для номенклатуры.
//
Процедура ДобавитьФайлы(Знач ВладелецФайла, Знач ИдентификаторФормы, Знач Фильтр = "") Экспорт
	
	РаботаСФайламиКлиент.ДобавитьФайлы(ВладелецФайла, ИдентификаторФормы, Фильтр);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ПодписатьФайл.
// Подписывает присоединенный файл.
//
// Параметры:
//  ПрисоединенныйФайл      - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы      - УникальныйИдентификатор - идентификатор управляемой формы.
//  ДополнительныеПараметры - Неопределено - стандартное поведение (см. ниже).
//                          - Структура - со свойствами:
//       * ДанныеФайла            - Структура - данные файла, если свойства нет, будет вставлено.
//       * ОбработкаРезультата    - ОписаниеОповещения - при вызове передается значение типа Булево,
//                                  если Истина - файл успешно подписан, иначе не подписан,
//                                  если свойства нет, оповещение не будет вызвано.
//
Процедура ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.ПодписатьФайл(ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.СохранитьВместеСЭП.
// Сохраняет файл вместе вместе с ЭП.
// Используется в обработчике команды сохранения файла.
//
// Параметры:
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ДанныеФайла        - Структура - (необязательный) - данные файла.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура СохранитьВместеСЭП(Знач ПрисоединенныйФайл, Знач ДанныеФайла, Знач ИдентификаторФормы) Экспорт
	
	РаботаСФайламиКлиент.СохранитьВместеСЭП(ПрисоединенныйФайл, ИдентификаторФормы);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.СохранитьФайлКак.
// Сохраняет файл в каталог на диске.
// Так же используется, как вспомогательная функция при сохранении файла с ЭП.
//
// Параметры:
//  ДанныеФайла  - Структура - данные файла.
//
// Возвращаемое значение:
//  Строка - имя сохраненного файла.
//
Процедура СохранитьФайлКак(Знач ДанныеФайла) Экспорт
	
	РаботаСФайламиКлиент.СохранитьФайлКак(ДанныеФайла);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ПерейтиКФормеФайла.
// Открывает общую форму присоединенного файла из формы элемента
// справочника присоединенных файлов. Форма элемента закрывается.
// 
// Параметры:
//  Форма     - УправляемаяФорма - форма справочника присоединенных файлов.
//
Процедура ПерейтиКФормеПрисоединенногоФайла(Знач Форма) Экспорт
	
	ПрисоединенныйФайл = Форма.Ключ;
	
	Форма.Закрыть();
	
	Для Каждого ОкноКП Из ПолучитьОкна() Цикл
		
		Содержимое = ОкноКП.ПолучитьСодержимое();
		
		Если Содержимое = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Если Содержимое.ИмяФормы = "Обработка.РаботаСФайлами.Форма.ПрисоединенныйФайл" Тогда
			Если Содержимое.Параметры.Свойство("ПрисоединенныйФайл")
				И Содержимое.Параметры.ПрисоединенныйФайл = ПрисоединенныйФайл Тогда
				ОкноКП.Активизировать();
				Возврат;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	РаботаСФайламиКлиент.ОткрытьФормуФайла(ПрисоединенныйФайл);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ОткрытьФормуВыбораФайлов.
// Открывает форму выбора файлов.
// Используется в обработчике выбора для переопределения стандартного поведения.
//
// Параметры:
//  ВладелецФайлов       - Ссылка - ссылка на объект с файлами.
//  ЭлементФормы         - ТаблицаФормы, ПолеФормы - элемент формы, которому будет отправлено
//                         оповещение о выборе.
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуВыбораФайлов(Знач ВладелецФайлов, Знач ЭлементФормы, СтандартнаяОбработка = Ложь) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ВладелецФайла", ВладелецФайлов);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ПрисоединенныеФайлы", ПараметрыФормы, ЭлементФормы);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ОткрытьФормуФайла.
// Открывает форму присоединенного файла.
// Может использоваться как обработчик открытия присоединенного файла.
//
// Параметры:
//  ПрисоединенныйФайл   - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  СтандартнаяОбработка - Булево - (возвращаемое значение), всегда устанавливается в Ложь.
//
Процедура ОткрытьФормуПрисоединенногоФайла(Знач ПрисоединенныйФайл, СтандартнаяОбработка = Ложь) Экспорт
	
	РаботаСФайламиКлиент.ОткрытьФормуФайла(ПрисоединенныйФайл, СтандартнаяОбработка);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ДанныеФайла.
// Возвращает структуру данных файла. Используется в различных командах работы с файлами,
// и как значение параметра ДанныеФайла других процедур и функций.
//
// Параметры:
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, который
//                       используется при получении двоичных данных файла.
//
//  ПолучатьСсылкуНаДвоичныеДанные - Булево - если передать Ложь, то ссылка на двоичные данные
//                 не будет получена, что существенно ускорит выполнение для больших двоичных данных.
//
//  ДляРедактирования - Булево - если указать Истина, то свободный файл будет захвачен для редактирования.
//
// Возвращаемое значение:
//  Структура - со свойствами:
//    * СсылкаНаДвоичныеДанныеФайла        - Строка - адрес во временном хранилище.
//    * ОтносительныйПуть                  - Строка - относительный путь файла.
//    * ДатаМодификацииУниверсальная       - Дата   - дата изменения фала.
//    * ИмяФайла                           - Строка - имя файла без точки.
//    * Наименование                       - Строка - наименование файла в справочнике хранения файлов.
//    * Расширение                         - Строка - расширение файла без точки.
//    * Размер                             - Число  - размер файла.
//    * Редактирует                        - СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи,
//                                           Неопределено - ссылка на пользователя, занявшего файл.
//    * ПодписанЭП                         - Булево - Истина, если файл подписан.
//    * Зашифрован                         - Булево - Истина, если файл зашифрован.
//    * ФайлРедактируется                  - Булево - Истина, если файл занят для редактирования.
//    * ФайлРедактируетТекущийПользователь - Булево - Истина, если файл занят для редактирования текущим пользователем.
//
Функция ПолучитьДанныеФайла(Знач ПрисоединенныйФайл,
                            Знач ИдентификаторФормы = Неопределено,
                            Знач ПолучатьСсылкуНаДвоичныеДанные = Истина,
                            Знач ДляРедактирования = Ложь) Экспорт
	
	Возврат РаботаСФайламиКлиент.ДанныеФайла(ПрисоединенныйФайл, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные,ДляРедактирования);
	
КонецФункции

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ПолучитьФайл.
// Получает файл из хранилища файлов в рабочий каталог пользователя.
// Аналог интерактивного действия Просмотреть или Редактировать без открытия полученного файла.
//   Свойство ТолькоПросмотр полученного файла будет установлено в зависимости от того захвачен
// файл для редактирования или нет. Если не захвачен - устанавливается только просмотр.
//   Если в рабочем каталоге уже существует файл, тогда он будет удален и заменен файлом,
// полученным из хранилища файлов.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после получения файла в
//   рабочий каталог пользователя. В качестве результата возвращается Структура со свойствами:
//     * ПолноеИмяФайла - Строка - полное имя файла (с путем).
//     * ОписаниеОшибки - Строка - текст ошибки, если получить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ДляРедактирования - Булево    - начальное значение Ложь. Если Истина,
//                                           тогда файл будет захвачен для редактирования.
//         * ДанныеФайла       - Структура - свойства файла, которые можно передать для ускорения
//                                           если они ранее были получены на клиент с сервера.
//
Процедура ПолучитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.ПолучитьПрисоединенныйФайл(
		Оповещение,
		ПрисоединенныйФайл,
		ИдентификаторФормы,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.ПоместитьФайл.
// Помещает файл из рабочего каталога пользователя в хранилище файлов.
// Аналог интерактивного действия Закончить редактирование.
//
// Параметры:
//  Оповещение - ОписаниеОповещения - оповещение, которое выполняется после помещения файла в
//   хранилище файлов. В качестве результата возвращается Структура со свойствами:
//     * ОписаниеОшибки - Строка - текст ошибки, если поместить файл не удалось.
//
//  ПрисоединенныйФайл - СправочникСсылка - ссылка на справочник с именем "*ПрисоединенныеФайлы".
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
//  ДополнительныеПараметры - Неопределено - использовать значения по умолчанию.
//     - Структура - с необязательными свойствами:
//         * ПолноеИмяФайла - Строка - если заполнено, то указанный файл будет помещен в рабочий каталог
//                                     пользователя, а затем в хранилище файлов.
//         * ДанныеФайла    - Структура - свойства файла, которые можно передать для ускорения
//                                        если они ранее были получены на клиент с сервера.
//
Процедура ПоместитьПрисоединенныйФайл(Оповещение, ПрисоединенныйФайл, ИдентификаторФормы, ДополнительныеПараметры = Неопределено) Экспорт
	
	РаботаСФайламиКлиент.ПоместитьПрисоединенныйФайл(
		Оповещение,
		ПрисоединенныйФайл,
		ИдентификаторФормы,
		ДополнительныеПараметры);
	
КонецПроцедуры

// Устарела.
// Следует использовать РаботаСФайламиКлиент.НапечататьФайлы.
// Выполняет печать файлов.
//
// Параметры:
//  ДанныеФайлов       - Массив - массив структур с данными файлов.
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор управляемой формы.
//
Процедура НапечататьФайлы(ДанныеФайлов, ИдентификаторФормы) Экспорт
	
	РаботаСФайламиКлиент.НапечататьФайлы(ДанныеФайлов, ИдентификаторФормы);

КонецПроцедуры

#КонецОбласти

#КонецОбласти
